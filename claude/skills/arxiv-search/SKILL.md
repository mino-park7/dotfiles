---
name: arxiv-search
description: Use when searching for academic papers, research references, or scientific literature on arxiv.org. Triggers when user asks to find papers, citations, related work, or state-of-the-art research on a topic.
---

# ArXiv Search

Search arxiv.org for academic papers and research references.

## Search Strategy

### 1. Construct Queries
Use multiple query variations to maximize coverage:
- Exact topic terms: `"transformer attention mechanism"`
- Broader synonyms: `"self-attention neural network"`
- Task-specific: `"image classification efficiency"`

### 2. Search Methods

**Primary - ArXiv Search URL:**
```
https://arxiv.org/search/?searchtype=all&query=QUERY&start=0
```

**Alternative - Semantic Scholar (broader):**
```
https://api.semanticscholar.org/graph/v1/paper/search?query=QUERY&fields=title,authors,year,abstract,citationCount,externalIds
```

**Papers With Code (with implementations):**
```
https://paperswithcode.com/search?q_meta=&q_type=&q=QUERY
```

### 3. Fetch and Extract

For each paper found, extract:
| Field | Description |
|-------|-------------|
| Title | Full paper title |
| Authors | First author et al. |
| Year | Publication year |
| ArXiv ID | e.g., `2301.00001` |
| Abstract | 2-3 sentence summary |
| Key contribution | Main novelty |
| Citations | Impact indicator |

### 4. ArXiv ID → Full Details
```
https://arxiv.org/abs/ARXIV_ID     # Abstract page
https://arxiv.org/pdf/ARXIV_ID     # PDF
```

## Output Format

```markdown
## ArXiv References: [Topic]

### Paper 1: [Title]
- **Authors:** First Author et al. (Year)
- **ArXiv:** [2301.00001](https://arxiv.org/abs/2301.00001)
- **Summary:** [2-3 sentences on contribution]
- **Relevance:** [Why this matters for the task]

### Paper 2: ...
```

## Search Tips

- Search 3-5 query variations before concluding nothing exists
- Filter by date for cutting-edge work: add `&start=0&searchtype=all&order=-announced_date_first`
- Check "Related papers" and "Cited by" for snowball search
- Cross-reference with Papers With Code for implementation availability

## Common Mistakes

- Stopping after first query with few results — try synonyms
- Missing seminal papers — search both recent AND classic terms
- Ignoring citation count — high-citation papers = foundational work
