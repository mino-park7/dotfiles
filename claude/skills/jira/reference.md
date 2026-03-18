# Jira Reference

## Authentication

Use Jira Cloud API tokens only. Do not use passwords.

### `curl -u email:token`

```bash
curl -s -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
  "$ATLASSIAN_BASE_URL/rest/api/3/myself" | jq .
```

### `Authorization: Basic <base64>`

```bash
AUTH_HEADER="$(printf '%s' "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" | base64)"

curl -s \
  -H "Authorization: Basic $AUTH_HEADER" \
  -H "Accept: application/json" \
  "$ATLASSIAN_BASE_URL/rest/api/3/myself" | jq .
```

## Common curl Template

```bash
curl -s -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -X GET \
  "$ATLASSIAN_BASE_URL/rest/api/3/<path>" \
  | jq .
```

## ADF Templates

Atlassian Document Format (ADF) is required for rich text fields such as descriptions and comments.

### Paragraph

```json
{
  "type": "doc",
  "version": 1,
  "content": [
    {
      "type": "paragraph",
      "content": [
        {
          "type": "text",
          "text": "Plain paragraph text"
        }
      ]
    }
  ]
}
```

### Heading h1

```json
{
  "type": "doc",
  "version": 1,
  "content": [
    {
      "type": "heading",
      "attrs": {"level": 1},
      "content": [{"type": "text", "text": "Heading 1"}]
    }
  ]
}
```

### Heading h2

```json
{
  "type": "doc",
  "version": 1,
  "content": [
    {
      "type": "heading",
      "attrs": {"level": 2},
      "content": [{"type": "text", "text": "Heading 2"}]
    }
  ]
}
```

### Heading h3

```json
{
  "type": "doc",
  "version": 1,
  "content": [
    {
      "type": "heading",
      "attrs": {"level": 3},
      "content": [{"type": "text", "text": "Heading 3"}]
    }
  ]
}
```

### Bullet List

```json
{
  "type": "doc",
  "version": 1,
  "content": [
    {
      "type": "bulletList",
      "content": [
        {
          "type": "listItem",
          "content": [
            {
              "type": "paragraph",
              "content": [{"type": "text", "text": "First bullet"}]
            }
          ]
        },
        {
          "type": "listItem",
          "content": [
            {
              "type": "paragraph",
              "content": [{"type": "text", "text": "Second bullet"}]
            }
          ]
        }
      ]
    }
  ]
}
```

### Ordered List

```json
{
  "type": "doc",
  "version": 1,
  "content": [
    {
      "type": "orderedList",
      "attrs": {"order": 1},
      "content": [
        {
          "type": "listItem",
          "content": [
            {
              "type": "paragraph",
              "content": [{"type": "text", "text": "First step"}]
            }
          ]
        },
        {
          "type": "listItem",
          "content": [
            {
              "type": "paragraph",
              "content": [{"type": "text", "text": "Second step"}]
            }
          ]
        }
      ]
    }
  ]
}
```

### Code Block With Language

```json
{
  "type": "doc",
  "version": 1,
  "content": [
    {
      "type": "codeBlock",
      "attrs": {"language": "bash"},
      "content": [
        {
          "type": "text",
          "text": "curl -s \"$ATLASSIAN_BASE_URL/rest/api/3/myself\""
        }
      ]
    }
  ]
}
```

### Table

```json
{
  "type": "doc",
  "version": 1,
  "content": [
    {
      "type": "table",
      "content": [
        {
          "type": "tableRow",
          "content": [
            {
              "type": "tableHeader",
              "content": [{"type": "paragraph", "content": [{"type": "text", "text": "Column A"}]}]
            },
            {
              "type": "tableHeader",
              "content": [{"type": "paragraph", "content": [{"type": "text", "text": "Column B"}]}]
            }
          ]
        },
        {
          "type": "tableRow",
          "content": [
            {
              "type": "tableCell",
              "content": [{"type": "paragraph", "content": [{"type": "text", "text": "Value 1"}]}]
            },
            {
              "type": "tableCell",
              "content": [{"type": "paragraph", "content": [{"type": "text", "text": "Value 2"}]}]
            }
          ]
        }
      ]
    }
  ]
}
```

### Plain Text to ADF Conversion Pattern

```json
{
  "type": "doc",
  "version": 1,
  "content": [
    {
      "type": "paragraph",
      "content": [
        {"type": "text", "text": "Line 1 from plain text"}
      ]
    },
    {
      "type": "paragraph",
      "content": [
        {"type": "text", "text": "Line 2 from plain text"}
      ]
    }
  ]
}
```

Map each paragraph of plain text into a separate `paragraph` node. For headings or lists, use the corresponding ADF node types instead of shoving everything into one paragraph.

## Issues API

### Create Issue

```bash
curl -s -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -X POST \
  "$ATLASSIAN_BASE_URL/rest/api/3/issue" \
  --data @- <<'EOF'
{
  "fields": {
    "project": {"key": "ENG"},
    "summary": "Example issue created via Jira Cloud API",
    "issuetype": {"name": "Task"},
    "description": {
      "type": "doc",
      "version": 1,
      "content": [
        {
          "type": "paragraph",
          "content": [{"type": "text", "text": "Created directly with curl."}]
        }
      ]
    }
  }
}
EOF
```

### Read Issue

```bash
ISSUE_KEY="ENG-123"

curl -s -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
  "$ATLASSIAN_BASE_URL/rest/api/3/issue/$ISSUE_KEY?fields=summary,status,assignee,description" | jq .
```

### Update Issue

```bash
curl -s -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -X PUT \
  "$ATLASSIAN_BASE_URL/rest/api/3/issue/$ISSUE_KEY" \
  --data @- <<'EOF'
{
  "fields": {
    "summary": "Updated summary from curl",
    "description": {
      "type": "doc",
      "version": 1,
      "content": [
        {
          "type": "paragraph",
          "content": [{"type": "text", "text": "Updated with ADF JSON."}]
        }
      ]
    }
  }
}
EOF
```

### Delete Issue

```bash
curl -s -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
  -H "Accept: application/json" \
  -X DELETE \
  "$ATLASSIAN_BASE_URL/rest/api/3/issue/$ISSUE_KEY"
```

## Transitions API

### List Available Transitions

```bash
curl -s -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
  "$ATLASSIAN_BASE_URL/rest/api/3/issue/$ISSUE_KEY/transitions" \
  | jq '.transitions[] | {id, name, to: .to.name}'
```

Always inspect the returned transition IDs before updating workflow state.

### Transition Issue

```bash
TRANSITION_ID="31"

curl -s -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -X POST \
  "$ATLASSIAN_BASE_URL/rest/api/3/issue/$ISSUE_KEY/transitions" \
  --data "{\"transition\":{\"id\":\"$TRANSITION_ID\"}}"
```

## Search API

Use the enhanced JQL endpoint with `nextPageToken` pagination.

### Search Once

```bash
curl -s -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -X POST \
  "$ATLASSIAN_BASE_URL/rest/api/3/search/jql" \
  --data @- <<'EOF'
{
  "jql": "project = ENG ORDER BY updated DESC",
  "fields": ["summary", "status", "assignee", "priority"],
  "maxResults": 50
}
EOF
```

### `nextPageToken` Pagination Loop

```bash
JQL='project = ENG AND statusCategory != Done ORDER BY updated DESC'
NEXT_PAGE_TOKEN=""

while :; do
  if [ -n "$NEXT_PAGE_TOKEN" ]; then
    RESPONSE="$(curl -s -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
      -H "Accept: application/json" \
      -H "Content-Type: application/json" \
      -X POST \
      "$ATLASSIAN_BASE_URL/rest/api/3/search/jql" \
      --data @- <<EOF
{
  "jql": "$JQL",
  "fields": ["summary", "status", "assignee", "priority"],
  "maxResults": 50,
  "nextPageToken": "$NEXT_PAGE_TOKEN"
}
EOF
    )"
  else
    RESPONSE="$(curl -s -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
      -H "Accept: application/json" \
      -H "Content-Type: application/json" \
      -X POST \
      "$ATLASSIAN_BASE_URL/rest/api/3/search/jql" \
      --data @- <<EOF
{
  "jql": "$JQL",
  "fields": ["summary", "status", "assignee", "priority"],
  "maxResults": 50
}
EOF
    )"
  fi

  printf '%s\n' "$RESPONSE" | jq -r '.issues[] | [.key, .fields.summary, .fields.status.name] | @tsv'
  NEXT_PAGE_TOKEN="$(printf '%s\n' "$RESPONSE" | jq -r '.nextPageToken // empty')"

  [ -z "$NEXT_PAGE_TOKEN" ] && break
done
```

## Comments API

### List Comments

```bash
curl -s -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
  "$ATLASSIAN_BASE_URL/rest/api/3/issue/$ISSUE_KEY/comment" \
  | jq '.comments[] | {id, author: .author.displayName, body}'
```

### Add Comment With ADF Body

```bash
curl -s -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
  -H "Accept: application/json" \
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
        "content": [{"type": "text", "text": "Investigation update posted from curl."}]
      }
    ]
  }
}
EOF
```

## Projects API

### List Projects

```bash
curl -s -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
  "$ATLASSIAN_BASE_URL/rest/api/3/project/search" | jq '.values[] | {key, name, projectTypeKey}'
```

### Get Project By Key

```bash
PROJECT_KEY="ENG"

curl -s -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
  "$ATLASSIAN_BASE_URL/rest/api/3/project/$PROJECT_KEY" | jq .
```

## Agile API

All Agile endpoints live under `/rest/agile/1.0/`.

### Get Boards

```bash
curl -s -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
  "$ATLASSIAN_BASE_URL/rest/agile/1.0/board" | jq '.values[] | {id, name, type}'
```

### Get Sprints

```bash
BOARD_ID="12"

curl -s -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
  "$ATLASSIAN_BASE_URL/rest/agile/1.0/board/$BOARD_ID/sprint?state=active,future,closed" \
  | jq '.values[] | {id, name, state, startDate, endDate}'
```

### Get Sprint Issues

```bash
SPRINT_ID="34"

curl -s -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
  "$ATLASSIAN_BASE_URL/rest/agile/1.0/sprint/$SPRINT_ID/issue" \
  | jq '.issues[] | {key, summary: .fields.summary, status: .fields.status.name, assignee: (.fields.assignee.displayName // "Unassigned")}'
```

## JQL Quick Reference

```text
project = ENG ORDER BY created DESC
project = ENG AND statusCategory != Done ORDER BY updated DESC
project = ENG AND assignee = currentUser() AND resolution = Unresolved
project = ENG AND priority in (Highest, High) AND labels = backend
project = ENG AND issuetype = Bug AND created >= -7d
project = ENG AND sprint in openSprints() ORDER BY Rank ASC
project = ENG AND reporter = currentUser() AND updated >= startOfWeek()
project = ENG AND text ~ "timeout" ORDER BY relevance DESC
project = ENG AND due <= endOfWeek() AND statusCategory != Done
project = ENG AND component = API AND fixVersion is EMPTY
```

## Pagination

Use `nextPageToken`, not `startAt`, for the enhanced search endpoint.

1. Send the first `POST /rest/api/3/search/jql` request without `nextPageToken`.
2. Inspect the response for `nextPageToken`.
3. If present, send the next request with the same JQL and the returned `nextPageToken`.
4. Repeat until `nextPageToken` is absent or empty.

```bash
NEXT_PAGE_TOKEN=""

while :; do
  BODY="{\"jql\":\"project = ENG ORDER BY updated DESC\",\"maxResults\":50}"

  if [ -n "$NEXT_PAGE_TOKEN" ]; then
    BODY="{\"jql\":\"project = ENG ORDER BY updated DESC\",\"maxResults\":50,\"nextPageToken\":\"$NEXT_PAGE_TOKEN\"}"
  fi

  RESPONSE="$(curl -s -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
    -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -X POST \
    "$ATLASSIAN_BASE_URL/rest/api/3/search/jql" \
    --data "$BODY")"

  NEXT_PAGE_TOKEN="$(printf '%s\n' "$RESPONSE" | jq -r '.nextPageToken // empty')"
  [ -z "$NEXT_PAGE_TOKEN" ] && break
done
```

## Error Format

Jira error responses commonly look like this:

```json
{
  "errorMessages": [
    "A human-readable top-level error"
  ],
  "errors": {
    "summary": "Summary is required",
    "description": "Operation value must be an Atlassian Document Format object"
  },
  "status": 400
}
```

## Rate Limits

- `429 Too Many Requests` means Jira throttled the request.
- Read the `Retry-After` header, sleep for that many seconds, then retry.
- Per-issue write limits apply: 20 operations per 2 seconds and 100 operations per 30 seconds.
- Batch user-visible updates carefully: transition once, then add one comment, then wait if a loop is writing many issue updates.

```bash
HTTP_HEADERS="$(mktemp)"

curl -s -D "$HTTP_HEADERS" -o /tmp/jira-response.json \
  -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
  -H "Accept: application/json" \
  "$ATLASSIAN_BASE_URL/rest/api/3/myself"

RETRY_AFTER="$(grep -i '^Retry-After:' "$HTTP_HEADERS" | tr -d '\r' | awk '{print $2}')"
[ -n "$RETRY_AFTER" ] && sleep "$RETRY_AFTER"
```
