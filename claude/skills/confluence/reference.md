# Confluence REST API Reference

## Authentication

Use the same Atlassian Cloud credentials shared with Jira.

```bash
# Load from .local.env in CWD or skill directory, or export manually:
# export ATLASSIAN_USER_EMAIL="you@example.com"
# export ATLASSIAN_API_TOKEN="your-api-token"
# export ATLASSIAN_BASE_URL="https://hyperaccel.atlassian.net/"

[ -f ".local.env" ] && set -a && . ".local.env" && set +a
: "${ATLASSIAN_BASE_URL:=https://hyperaccel.atlassian.net/}"
AUTH_ARGS=(-u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN")
```

All examples assume Confluence Cloud and basic auth with email plus API token.

## Common curl Templates

### v2 template for pages and spaces

```bash
curl -s "${AUTH_ARGS[@]}" \
  -H "Accept: application/json" \
  "$ATLASSIAN_BASE_URL/wiki/api/v2/pages/{id}"
```

### v1 template for CQL search

```bash
CQL='type = page AND text ~ "runbook"'

curl -s "${AUTH_ARGS[@]}" \
  -H "Accept: application/json" \
  --get \
  --data-urlencode "cql=$CQL" \
  --data-urlencode "limit=10" \
  --data-urlencode "expand=excerpt" \
  "$ATLASSIAN_BASE_URL/wiki/rest/api/search"
```

## Pages API (v2)

### Get page by ID with storage body

```bash
curl -s "${AUTH_ARGS[@]}" \
  -H "Accept: application/json" \
  "$ATLASSIAN_BASE_URL/wiki/api/v2/pages/{id}?body-format=storage" | jq
```

### Get page by ID with ADF body

```bash
curl -s "${AUTH_ARGS[@]}" \
  -H "Accept: application/json" \
  "$ATLASSIAN_BASE_URL/wiki/api/v2/pages/{id}?body-format=atlas_doc_format" | jq
```

### Create page

```bash
curl -s "${AUTH_ARGS[@]}" \
  -X POST \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  "$ATLASSIAN_BASE_URL/wiki/api/v2/pages" \
  -d '{
    "spaceId": "123456",
    "status": "current",
    "title": "Release Runbook",
    "body": {
      "representation": "storage",
      "value": "<h1>Release Runbook</h1><p>Ready for rollout.</p>"
    }
  }' | jq '{id, title, status, _links}'
```

### Update page with version bump

```bash
PAGE_ID="123456"
CURRENT_VERSION=$(curl -s "${AUTH_ARGS[@]}" \
  -H "Accept: application/json" \
  "$ATLASSIAN_BASE_URL/wiki/api/v2/pages/$PAGE_ID?body-format=storage" | jq '.version.number')

curl -s "${AUTH_ARGS[@]}" \
  -X PUT \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  "$ATLASSIAN_BASE_URL/wiki/api/v2/pages/$PAGE_ID" \
  -d "{
    \"id\": \"$PAGE_ID\",
    \"status\": \"current\",
    \"title\": \"Release Runbook\",
    \"version\": {\"number\": $((CURRENT_VERSION + 1))},
    \"body\": {
      \"representation\": \"storage\",
      \"value\": \"<h1>Release Runbook</h1><p>Updated content.</p>\"
    }
  }" | jq '{id, title, version}'
```

### Delete page

```bash
curl -s "${AUTH_ARGS[@]}" \
  -X DELETE \
  -H "Accept: application/json" \
  "$ATLASSIAN_BASE_URL/wiki/api/v2/pages/{id}"
```

Delete moves the page to trash; permanent purge is a separate action.

## Search API (v1)

Use the v1 search API because Confluence search still lives under `/wiki/rest/api/search`.

```bash
CQL='type = page AND space = "ENG" AND text ~ "scheduler"'

curl -s "${AUTH_ARGS[@]}" \
  -H "Accept: application/json" \
  --get \
  --data-urlencode "cql=$CQL" \
  --data-urlencode "limit=10" \
  --data-urlencode "expand=excerpt" \
  "$ATLASSIAN_BASE_URL/wiki/rest/api/search" |
jq '.results[] | {
  id: .content.id,
  title: .content.title,
  space: .space.key,
  url: .url,
  excerpt: .excerpt
}'
```

## Spaces API (v2)

### List spaces

```bash
curl -s "${AUTH_ARGS[@]}" \
  -H "Accept: application/json" \
  "$ATLASSIAN_BASE_URL/wiki/api/v2/spaces?limit=25" |
jq '.results[] | {id, key, name, type}'
```

### Get space by key or ID

```bash
SPACE_KEY="ENG"

curl -s "${AUTH_ARGS[@]}" \
  -H "Accept: application/json" \
  "$ATLASSIAN_BASE_URL/wiki/api/v2/spaces?keys=$SPACE_KEY" | jq '.results[0]'

curl -s "${AUTH_ARGS[@]}" \
  -H "Accept: application/json" \
  "$ATLASSIAN_BASE_URL/wiki/api/v2/spaces/{id}" | jq
```

## CQL Quick Reference

```text
type = page AND space = "SPACEKEY"
title = "Exact Page Title"
text ~ "search term"
label = "my-label"
creator = currentUser()
lastModified >= "2024-01-01"
ancestor = 123456
```

Combine clauses with `AND` / `OR`, and URL-encode the full CQL string when calling the search endpoint.

## Storage Format Examples

```xml
<p>text</p>
<h1>Main heading</h1>
<h2>Section heading</h2>
<h3>Subsection heading</h3>
<ul><li>item</li></ul>
<ol><li>item</li></ol>
<ac:structured-macro ac:name="code"><ac:parameter ac:name="language">python</ac:parameter><ac:plain-text-body><![CDATA[print("hello")]]></ac:plain-text-body></ac:structured-macro>
<table><tbody><tr><th>Header</th></tr><tr><td>Data</td></tr></tbody></table>
```

Confluence storage format is XHTML-like markup. It is not Markdown, and macro tags must remain well-formed.

## Version Bump Pattern

```bash
# Step 1: Get current version
VERSION=$(curl -s -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
  "$ATLASSIAN_BASE_URL/wiki/api/v2/pages/{id}" | jq .version.number)

# Step 2: PUT with version+1
curl -s -u "$ATLASSIAN_USER_EMAIL:$ATLASSIAN_API_TOKEN" \
  -X PUT -H "Content-Type: application/json" \
  "$ATLASSIAN_BASE_URL/wiki/api/v2/pages/{id}" \
  -d "{\"id\":\"{id}\",\"version\":{\"number\":$((VERSION+1))},\"title\":\"...\",\"body\":{...}}"
```

Always GET the current version before PUT. If another edit lands first, repeat the fetch and retry with the next version number.

## Pagination

Confluence pagination uses cursor-like links in `_links.next` instead of Jira's `nextPageToken` style.

```bash
NEXT_URL="$ATLASSIAN_BASE_URL/wiki/api/v2/spaces?limit=25"

while [ -n "$NEXT_URL" ] && [ "$NEXT_URL" != "null" ]; do
  RESPONSE=$(curl -s "${AUTH_ARGS[@]}" -H "Accept: application/json" "$NEXT_URL")
  printf '%s\n' "$RESPONSE" | jq '.results[] | {id, key, name}'
  NEXT_PATH=$(printf '%s\n' "$RESPONSE" | jq -r '._links.next // empty')
  if [ -n "$NEXT_PATH" ]; then
    NEXT_URL="$ATLASSIAN_BASE_URL$NEXT_PATH"
  else
    NEXT_URL=""
  fi
done
```

## Error Format

Confluence errors commonly look like this:

```json
{"statusCode":404,"data":{"errors":[{"message":{"key":"..."}}]},"message":"Not Found"}
```

Inspect `statusCode`, `message`, and `data.errors` to decide whether to retry, request a permission change, or fix the request payload.
