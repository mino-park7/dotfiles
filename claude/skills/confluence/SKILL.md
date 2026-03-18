---
name: confluence
description: "Interact with Confluence Cloud via REST API — create pages, update content, search with CQL, read documentation, and manage spaces. Use this skill whenever the user mentions Confluence pages, wiki, documentation, knowledge base, spaces, or anything related to Confluence content management, even if they don't explicitly say 'Confluence'."
---

# Confluence — Atlassian Confluence Cloud REST API

Call the Confluence Cloud REST API directly with `curl` and `jq` for page, space, and search workflows.

## Agent Behavior

- **Do NOT ask for user confirmation** before executing read (GET) or search API calls.
- **Do NOT ask for permission** at each step — proceed autonomously through the entire workflow.
- Only pause to confirm with the user before **destructive writes** (DELETE page) or when the user's intent is genuinely ambiguous.
- Chain multiple API calls in sequence without intermediate approval prompts.

## Prerequisites

- `curl` and `jq` installed
- Atlassian Cloud account (NOT Server/Data Center)
- API token from `https://id.atlassian.com/manage-profile/security/api-tokens`

### Credential bootstrap (auto)

Same mechanism as Jira skill. The agent MUST execute steps 1-3 automatically without user intervention.

**IMPORTANT — use an absolute path for `.local.env`:**

The agent MUST substitute `<project_root>` with the **actual workspace root absolute path** (the directory the user opened in their IDE). Never rely on shell `pwd` or `$PROJECT_ROOT` — resolve the real path yourself and hard-code it into the commands you run.

1. **Check** whether `<project_root>/.local.env` exists.
2. **If missing**, copy the template automatically:
   ```bash
   cp <skill_dir>/.local.env.example <project_root>/.local.env
   ```
3. **If the file still contains placeholder values** (`you@example.com` or `your-api-token`), open it in the user's editor:
   ```bash
   ${EDITOR:-cursor} <project_root>/.local.env
   ```
   > **SECURITY**: NEVER ask the user to paste API tokens into the chat. Tokens are secrets — they must only be entered directly in the `.local.env` file via an editor. Tell the user: "`.local.env` 파일을 열었습니다. `ATLASSIAN_USER_EMAIL`과 `ATLASSIAN_API_TOKEN`을 입력한 뒤 저장해 주세요."
4. Wait for the user to confirm they have saved the file, then **source** using the `eval` pattern (handles quoted values reliably):
   ```bash
   eval $(grep -v '^#' <project_root>/.local.env | grep '=' | sed 's/^/export /')
   ```
   **WARNING**: Do NOT use `set -a && source .local.env && set +a` — it fails silently when values contain double quotes, producing empty variables.
5. **Validate** credentials in one shot:
   ```bash
   curl -s -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
     "$ATLASSIAN_BASE_URL/wiki/api/v2/spaces?limit=1" | jq '.results[0].name'
   ```

- NOTE: Uses TWO API versions — v2 (`/wiki/api/v2/`) for page CRUD, v1 (`/wiki/rest/api/`) for search

## Workflow

### Scenario 1: Create a New Page

1. List spaces with `GET /wiki/api/v2/spaces` and identify the target space ID and key.
2. Construct the page body in Confluence storage format; use `reference.md` storage examples for valid XHTML-like markup.
3. Create the page with `POST /wiki/api/v2/pages` using a payload like `{"spaceId":"<id>","title":"Page Title","body":{"representation":"storage","value":"<xhtml>"},"status":"current"}`.
4. Return the final page URL to the user as `$ATLASSIAN_BASE_URL/wiki/spaces/{spaceKey}/pages/{pageId}`.

### Scenario 2: Update an Existing Page ⚠️ Version bump required

1. Find the page first, either with `GET /wiki/rest/api/search?cql=title="Page Title"` or directly with `GET /wiki/api/v2/pages/{id}?body-format=storage`.
2. Extract the current version number from `.version.number`, for example with `jq '.version.number'`.
3. Construct the updated storage-format page body.
4. Update the page with `PUT /wiki/api/v2/pages/{id}` and include `"version":{"number": currentVersion+1}` in the JSON payload.
5. If the API returns `409 Conflict`, re-fetch the page, get the latest version, increment it, and retry.

**WARNING**: Omitting the version bump causes `409 Conflict`. Always GET first, then PUT with incremented version.

### Scenario 3: Search Pages (CQL)

1. Translate the user's request into CQL using the patterns in `reference.md`.
2. Search with `GET /wiki/rest/api/search?cql=...&limit=10&expand=excerpt`.
3. Parse the results with `jq` and show title, space, web UI URL, and excerpt.
4. If the user needs full content, fetch the page with `GET /wiki/api/v2/pages/{id}?body-format=storage`.

### Scenario 4: Read Page Content

1. Fetch the page with `GET /wiki/api/v2/pages/{id}?body-format=storage` or `GET /wiki/api/v2/pages/{id}?body-format=atlas_doc_format`.
2. Parse the storage body (XHTML-like) or ADF payload depending on the requested output.
3. Summarize the content in readable prose for the user and preserve important headings, lists, and code blocks.

## Error Handling

| Error | Action |
|-------|--------|
| 401 Unauthorized | Check env vars; API token may have expired (max 365 days) |
| 403 Forbidden | User lacks permission for this space/page |
| 404 Not Found | Page ID or space key doesn't exist |
| 409 Conflict | Version mismatch on update — re-fetch current version, increment, and retry |
| 429 Too Many Requests | Rate limited. Read `Retry-After` header, wait, then retry |
| 400 Bad Request | Check JSON payload. Confluence returns `{"statusCode":N,"data":{"errors":[...]},"message":"..."}` |
| `ATLASSIAN_*` vars not set | Inform user to export required environment variables |

## Example Usage

1. "Create a new Confluence page in the ENG space titled 'Release Runbook' with rollout and rollback sections."
2. "Search Confluence for pages mentioning 'GPU scheduler' updated this year and show excerpts."
3. "Update page 123456 with the latest deployment checklist, preserving the current title and bumping the version correctly."

## Notes

- Two API versions: v2 for page CRUD (`/wiki/api/v2/`), v1 for search (`/wiki/rest/api/`)
- Page updates ALWAYS require version bump — GET current version, PUT with version+1
- Confluence uses storage format (XHTML-like) for page bodies; ADF also supported
- Same env vars as Jira skill — if Jira configured, Confluence works too
- For page body updates with CDATA/newlines, prefer Python `urllib.request` over `curl`+`jq` — CDATA sections in Confluence storage format break `jq` JSON parsing
- See `reference.md` for full curl templates and CQL syntax
