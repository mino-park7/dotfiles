---
name: github-codebase-search
description: Use when searching for open-source implementations, code repositories, or reference codebases on GitHub. Triggers when user asks to find code, implementations, libraries, or projects related to a technical topic.
---

# GitHub Codebase Search

Search GitHub for relevant code repositories and implementations.

## Search Strategy

### 1. GitHub Search URL
```
https://github.com/search?q=QUERY&type=repositories&sort=stars&order=desc
```

**Search by topic tag:**
```
https://github.com/topics/TOPIC-NAME
```

**Search with filters:**
```
https://github.com/search?q=QUERY+language:python+stars:>100&type=repositories
```

### 2. Query Construction

Build 3 query types:
| Type | Example |
|------|---------|
| Exact name | `"diffusion model"` |
| Task + framework | `transformer pytorch implementation` |
| Paper title | `"Attention Is All You Need" code` |

### 3. Repository Evaluation Criteria

For each repo, assess:
| Signal | Threshold |
|--------|-----------|
| Stars | >100 = notable, >1000 = popular |
| Last commit | <1 year = active |
| README quality | Clear install + usage |
| License | Check for commercial use |
| Issues/PRs | Active community |

### 4. Cloning the Repository

When you need the full codebase (not just a few files), clone it:
```bash
git clone https://github.com/owner/repo.git
```

For large repos, use shallow clone to save time:
```bash
git clone --depth 1 https://github.com/owner/repo.git
```

### 5. Key Files to Inspect

After cloning or fetching a repo, check these paths:
- `README.md` — overview, installation, usage
- `requirements.txt` / `setup.py` / `pyproject.toml` — dependencies
- Key source files matching the topic

## Output Format

```markdown
## GitHub Codebases: [Topic]

### Repo 1: [owner/repo-name](https://github.com/owner/repo)
- **Stars:** 3.2k | **Language:** Python | **Updated:** 2024-11
- **Description:** [What it implements]
- **Key files:** `src/model.py`, `train.py`
- **Usage:** `pip install X` then `python train.py`
- **Relevance:** [Why useful for the task]

### Repo 2: ...
```

## Search Tips

- Use `Papers With Code` links — papers often link to official implementations
- Search `awesome-TOPIC` repos for curated lists
- Check org accounts (e.g., huggingface, facebookresearch, google-research) directly
- Look at forks of popular repos for improvements/variants

## Common Mistakes

- Only checking star count — a 50-star specialized repo may be more relevant
- Skipping README — always verify the repo solves the right problem
- Missing official implementations — check paper authors' GitHub profiles
