---
name: deepwiki-search
description: Use when searching for codebase architecture, structure, or documentation of open-source GitHub repositories via DeepWiki. Triggers when user asks to understand a repo's architecture, internals, codebase structure, or how a specific subsystem works in an open-source project.
---

# DeepWiki Codebase Search

Fetch AI-generated codebase documentation from [DeepWiki](https://deepwiki.com/) for GitHub repositories.

## What is DeepWiki?

DeepWiki provides AI-generated architectural documentation for GitHub repositories. It analyzes codebases and produces structured wiki-style pages covering architecture, subsystems, source file mappings, and dependency relationships — with Mermaid diagrams and source references.

## URL Patterns

### Repository Index (Table of Contents)
```
https://deepwiki.com/{owner}/{repo}
```
Example: `https://deepwiki.com/microsoft/vscode`

### Specific Topic Page
```
https://deepwiki.com/{owner}/{repo}/{number}-{topic-name}
```
Examples:
- `https://deepwiki.com/microsoft/vscode/1-vs-code-codebase-overview`
- `https://deepwiki.com/microsoft/vscode/3-extension-system`
- `https://deepwiki.com/microsoft/vscode/1.1-application-startup-and-process-architecture`

Topics use a numerical taxonomy: `1`, `1.1`, `2`, `3.2`, etc.

## Search Strategy

### Step 1: Fetch the Repository Index

Fetch the repo's DeepWiki index page to get the table of contents:
```
https://deepwiki.com/{owner}/{repo}
```

Use WebFetch with a prompt like:
> "List all available topic pages with their URLs and brief descriptions. Show the full table of contents."

### Step 2: Identify Relevant Topics

From the table of contents, identify which topic pages are relevant to the user's question. Topics are organized hierarchically:
- Top-level sections (1, 2, 3, ...) cover major subsystems
- Sub-sections (1.1, 1.2, 2.1, ...) cover specific aspects

### Step 3: Fetch Specific Topic Pages

Fetch the relevant topic pages using WebFetch:
```
https://deepwiki.com/{owner}/{repo}/{number}-{topic-name}
```

Use targeted prompts to extract the information the user needs:
- Architecture: "Describe the architecture, process model, and key components"
- Source mapping: "List the key source files and their responsibilities"
- Data flow: "Explain how data flows between components"
- APIs: "Describe the public API surface and extension points"

### Step 4: Deep Dive (if needed)

For sub-topics, fetch the detailed pages:
```
https://deepwiki.com/{owner}/{repo}/{N.M}-{subtopic-name}
```

## Output Format

```markdown
## DeepWiki: [owner/repo] — [Topic]

**Source:** [DeepWiki page URL]

### Architecture Overview
[Key architectural insights from the wiki]

### Key Components
| Component | Source Path | Responsibility |
|-----------|-----------|----------------|
| [Name] | `src/path/file.ts` | [What it does] |

### Key Insights
- [Important architectural decisions]
- [Dependencies and relationships]
- [Patterns used]

### Related Topics
- [Link to related DeepWiki pages for further reading]
```

## Tips

- **Start with the index page** — always fetch the TOC first to understand what's available
- **Not all repos are indexed** — DeepWiki primarily covers popular open-source repos (high star count)
- **Combine with GitHub search** — use DeepWiki for architecture understanding, GitHub for actual code
- **Use specific prompts** — DeepWiki pages can be long; ask WebFetch for exactly what you need
- **Check sub-pages** — top-level pages give overviews; sub-pages (N.M) have implementation details

## Common Mistakes

- Guessing topic URLs without checking the index first — always fetch the TOC
- Trying to fetch private or low-popularity repos — DeepWiki may not have them indexed
- Fetching only the overview page — sub-topic pages contain the real architectural depth
