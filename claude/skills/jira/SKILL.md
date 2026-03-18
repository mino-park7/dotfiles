---
name: jira
description: "Interact with Jira Cloud via REST API — create issues, search with JQL, view details, update fields, transition workflow states, add comments, list projects, and browse boards/sprints. Use this skill whenever the user mentions Jira tickets, issues, sprints, boards, JQL, or anything related to Jira project management, even if they don't explicitly say 'Jira'."
---

# Jira — Atlassian Jira Cloud REST API

Use Jira Cloud directly with `curl` and `jq` instead of relying on the Atlassian MCP.

## Agent Behavior

- **Do NOT ask for user confirmation** before executing read (GET) or search API calls.
- **Do NOT ask for permission** at each step — proceed autonomously through the entire workflow.
- Only pause to confirm with the user before **destructive writes** (DELETE issue) or when the user's intent is genuinely ambiguous.
- Chain multiple API calls in sequence without intermediate approval prompts.

## Prerequisites

- `curl` and `jq` installed
- Atlassian Cloud account (NOT Server/Data Center)
- API token from <https://id.atlassian.com/manage-profile/security/api-tokens>

### Credential bootstrap (auto)

Before the first API call, run this sequence. The agent MUST execute steps 1-3 automatically without user intervention.

**IMPORTANT — use an absolute path for `.local.env`:**

The agent MUST substitute `<project_root>` with the **actual workspace root absolute path** (the directory the user opened in their IDE). Never rely on shell `pwd` or `$PROJECT_ROOT` — resolve the real path yourself and hard-code it into the commands you run.

1. **Check** whether `<project_root>/.local.env` exists.
2. **If missing**, copy the template automatically:

```bash
cp <skill_dir>/.local.env.example <project_root>/.local.env
```

3. **If the file still contains placeholder values** (`you@example.com` or `your-api-token`), open it in the user's editor so they can fill in credentials privately:

```bash
${EDITOR:-cursor} <project_root>/.local.env
```

   > **SECURITY**: NEVER ask the user to paste API tokens into the chat. Tokens are secrets — they must only be entered directly in the `.local.env` file via an editor. Tell the user: "`.local.env` 파일을 열었습니다. `ATLASSIAN_USER_EMAIL`과 `ATLASSIAN_API_TOKEN`을 입력한 뒤 저장해 주세요."

4. Wait for the user to confirm they have saved the file, then **source** and apply the base URL default:

```bash
set -a && source <project_root>/.local.env && set +a
: "${ATLASSIAN_BASE_URL:=https://hyperaccel.atlassian.net/}"
```

5. **Validate** credentials in one shot:

```bash
curl -s -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
  "$ATLASSIAN_BASE_URL/rest/api/3/myself" | jq .displayName
```

## Workflow

### Scenario 1: Create Issue from Context

1. List projects to find the right project key.

```bash
curl -s -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
  "$ATLASSIAN_BASE_URL/rest/api/3/project/search" | jq '.values[] | {key, name}'
```

2. Get issue types for that project.

```bash
PROJECT_KEY="ENG"

curl -s -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
  "$ATLASSIAN_BASE_URL/rest/api/3/issue/createmeta/$PROJECT_KEY/issuetypes" | jq .
```

3. Construct an Atlassian Document Format (ADF) description using the templates in `reference.md`.
4. Create the issue with `project.key`, `summary`, `description` (ADF), and `issuetype.name`.

```bash
curl -s -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
  -H "Content-Type: application/json" \
  -X POST \
  "$ATLASSIAN_BASE_URL/rest/api/3/issue" \
  --data @- <<'EOF'
{
  "fields": {
    "project": {"key": "ENG"},
    "summary": "Investigate intermittent API timeout in worker pool",
    "issuetype": {"name": "Task"},
    "description": {
      "type": "doc",
      "version": 1,
      "content": [
        {
          "type": "paragraph",
          "content": [
            {
              "type": "text",
              "text": "Context, reproduction steps, and expected behavior go here."
            }
          ]
        }
      ]
    }
  }
}
EOF
```

5. Return the new issue key and URL to the user.

```bash
ISSUE_KEY="ENG-123"
printf '%s\n' "$ISSUE_KEY" "$ATLASSIAN_BASE_URL/browse/$ISSUE_KEY"
```

### Scenario 2: Search Issues with JQL

1. Construct JQL from the user request using the patterns in `reference.md`.
2. Search with the enhanced Jira Cloud endpoint.

```bash
curl -s -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
  -H "Content-Type: application/json" \
  -X POST \
  "$ATLASSIAN_BASE_URL/rest/api/3/search/jql" \
  --data @- <<'EOF'
{
  "jql": "project = ENG AND statusCategory != Done ORDER BY updated DESC",
  "fields": ["summary", "status", "assignee", "priority"],
  "maxResults": 20
}
EOF
```

3. Parse and display formatted results with `jq`.

```bash
jq '.issues[] | {key, summary: .fields.summary, status: .fields.status.name, assignee: (.fields.assignee.displayName // "Unassigned"), priority: (.fields.priority.name // "None")}'
```

4. If more results exist, paginate using `nextPageToken` from the response.

### Scenario 3: Work on a Ticket

1. Fetch the issue and current workflow context.

```bash
ISSUE_KEY="ENG-123"

curl -s -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
  "$ATLASSIAN_BASE_URL/rest/api/3/issue/$ISSUE_KEY?expand=transitions" | jq .
```

2. Display the summary, description, status, assignee, and comments.
3. Start work by fetching transitions, locating `In Progress` or the equivalent state, and posting that transition ID.

```bash
curl -s -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
  "$ATLASSIAN_BASE_URL/rest/api/3/issue/$ISSUE_KEY/transitions" \
  | jq '.transitions[] | {id, name}'

TRANSITION_ID="31"

curl -s -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
  -H "Content-Type: application/json" \
  -X POST \
  "$ATLASSIAN_BASE_URL/rest/api/3/issue/$ISSUE_KEY/transitions" \
  --data "{\"transition\":{\"id\":\"$TRANSITION_ID\"}}"
```

4. Add a progress comment in ADF format.

```bash
curl -s -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
  -H "Content-Type: application/json" \
  -X POST \
  "$ATLASSIAN_BASE_URL/rest/api/3/issue/$ISSUE_KEY/comment" \
  --data @- <<'EOF'
{
  "body": {
    "type": "doc",
    "version": 1,
    "content": [
      {
        "type": "paragraph",
        "content": [
          {
            "type": "text",
            "text": "Started investigation and reproduced the issue locally."
          }
        ]
      }
    ]
  }
}
EOF
```

5. Complete the work by fetching transitions again, finding `Done`, applying that transition, and leaving a completion comment.

### Scenario 4: Update Issue

1. Get the current issue first so only intended fields change.

```bash
curl -s -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
  "$ATLASSIAN_BASE_URL/rest/api/3/issue/$ISSUE_KEY" | jq .fields
```

2. Construct a `PUT` payload with only the changed fields.
3. Send the update request.

```bash
curl -s -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
  -H "Content-Type: application/json" \
  -X PUT \
  "$ATLASSIAN_BASE_URL/rest/api/3/issue/$ISSUE_KEY" \
  --data @- <<'EOF'
{
  "fields": {
    "summary": "Investigate intermittent API timeout in worker pool",
    "description": {
      "type": "doc",
      "version": 1,
      "content": [
        {
          "type": "paragraph",
          "content": [
            {
              "type": "text",
              "text": "Updated context and latest findings."
            }
          ]
        }
      ]
    }
  }
}
EOF
```

4. Re-fetch the issue and confirm the change.

### Scenario 5: Sprint Overview (Agile)

1. List boards from the Jira Agile API.

```bash
curl -s -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
  "$ATLASSIAN_BASE_URL/rest/agile/1.0/board" | jq '.values[] | {id, name, type}'
```

2. List active sprints for the selected board.

```bash
BOARD_ID="12"

curl -s -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
  "$ATLASSIAN_BASE_URL/rest/agile/1.0/board/$BOARD_ID/sprint?state=active" \
  | jq '.values[] | {id, name, state}'
```

3. List issues in the active sprint.

```bash
SPRINT_ID="34"

curl -s -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
  "$ATLASSIAN_BASE_URL/rest/agile/1.0/sprint/$SPRINT_ID/issue" \
  | jq '.issues[] | {key, summary: .fields.summary, status: .fields.status.name, assignee: (.fields.assignee.displayName // "Unassigned")}'
```

4. Display each issue's summary, status, and assignee.

## Error Handling

| Error | Action |
|-------|--------|
| 401 Unauthorized | Check env vars; token may have expired (max 365 days). Re-validate with GET `/rest/api/3/myself` |
| 403 Forbidden | User lacks permission for this project/operation |
| 404 Not Found | Issue key/project doesn't exist. Verify format (for example `PROJ-123`) |
| 429 Too Many Requests | Rate limited. Read `Retry-After` header, wait, then retry |
| 400 Bad Request | Check JSON payload. Jira returns `{"errorMessages":[],"errors":{"field":"message"}}` |
| `ATLASSIAN_*` vars not set | Inform user to export required environment variables |
| `curl`/`jq` not found | Inform user to install: `brew install curl jq` (macOS) or `apt install curl jq` (Linux) |

## Example Usage

1. "Create a Jira task in `ENG` for the flaky worker timeout and include my reproduction notes."
2. "Show me all high-priority backend bugs assigned to me that changed this week."
3. "Move `ENG-123` to In Progress, add a status comment, and summarize the active sprint."

## Notes

- Always use Jira v3 API (ADF for descriptions/comments)
- Never plain text where ADF JSON expected — use `reference.md` templates
- For transitions, always fetch transitions first (IDs vary per workflow)
- Agile endpoints use `/rest/agile/1.0/` base path
- See `reference.md` for full curl templates, ADF format, and JQL syntax
