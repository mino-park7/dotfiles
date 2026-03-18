---
name: information-combiner
description: Use when synthesizing information from multiple research sources (papers, repos, blogs) into a coherent knowledge base. Triggers when multiple references have been gathered and need to be integrated, deduplicated, or cross-referenced.
---

# Information Combiner

Synthesize findings from multiple sources into a unified, coherent knowledge structure.

## Combination Process

### 1. Inventory All Sources
List every source collected with type tag:
```
[PAPER] Title — arxiv:2301.00001
[CODE]  owner/repo — github.com/...
[BLOG]  Post Title — url
```

### 2. Extract Key Dimensions

For each source, extract along these axes:

| Dimension | Questions to Answer |
|-----------|-------------------|
| **Core claim** | What is the main contribution/finding? |
| **Method** | How does it work? Key techniques? |
| **Results** | Benchmarks, metrics, comparisons |
| **Limitations** | What doesn't it solve? |
| **Dependencies** | What prior work does it build on? |
| **Date** | When was this published/updated? |

### 3. Cross-Reference Analysis

Build a comparison matrix for the key sources:

```markdown
| Aspect       | Source A | Source B | Source C |
|--------------|----------|----------|----------|
| Method       | ...      | ...      | ...      |
| Dataset      | ...      | ...      | ...      |
| Performance  | ...      | ...      | ...      |
| Code avail.  | ✓        | ✗        | ✓        |
```

### 4. Identify Relationships

Mark relationships between sources:
- **Extends:** Source B builds on Source A
- **Contradicts:** Source C disputes claim in Source A
- **Replicates:** Source B reproduces Source A's results
- **Applies:** Blog explains Paper; Repo implements Paper
- **Compares:** Source C benchmarks A vs B

### 5. Gap Analysis

After mapping sources, identify:
- Questions raised but not answered
- Missing comparisons (e.g., no open-source implementation)
- Conflicting claims needing resolution
- Recency gaps (latest paper vs current SOTA)

## Output Format

```markdown
## Combined Research Summary: [Topic]

### Key Themes
1. [Theme 1]: [Sources that cover this] — [consensus finding]
2. [Theme 2]: [Sources] — [finding]

### Source Relationships
- [Paper A] → implemented by → [Repo B]
- [Paper A] → explained by → [Blog C]
- [Paper D] → improves upon → [Paper A]

### Comparison Matrix
| ... | ... |

### Consensus Findings
- [Finding 1]: Agreed upon by [Source A, B, C]
- [Finding 2]: ...

### Contradictions / Open Questions
- [Contradiction]: [Source A] claims X, [Source B] claims Y
- [Open question]: No source covers Z

### Recommended Reading Order
1. [Blog C] — best intuitive introduction
2. [Paper A] — foundational method
3. [Repo B] — practical implementation
```

## Common Mistakes

- Treating all sources equally — weight recency and citation count
- Missing implicit contradictions — compare numbers, not just claims
- Skipping gap analysis — gaps often reveal research opportunities
- Summarizing each source separately instead of synthesizing across them
