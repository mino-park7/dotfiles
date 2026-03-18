---
name: research-report
description: Use when writing a structured research report that synthesizes findings from papers, code, and blogs into a final document. Triggers when user asks to write a report, summary document, literature review, or research brief on a topic.
---

# Research Report

Write a well-structured research report from gathered and combined sources.

## Report Structure

```markdown
# [Topic]: Research Report

## Executive Summary
[3-5 sentences: What is the topic, why it matters, key findings, recommendation]

## 1. Background & Motivation
- Problem definition
- Why this problem matters (applications, impact)
- Scope of this report

## 2. Key Concepts & Terminology
| Term | Definition |
|------|------------|
| ... | ... |

## 3. Current State of the Art
### 3.1 [Approach/Method A]
- **Papers:** [citations]
- **How it works:** [brief technical summary]
- **Performance:** [key metrics]
- **Limitations:** [what it doesn't solve]

### 3.2 [Approach/Method B]
...

## 4. Available Implementations
| Repository | Stars | What it implements | Notes |
|------------|-------|--------------------|-------|
| [owner/repo](url) | ⭐ 2k | ... | ... |

## 5. Practical Guidance
### Getting Started
[Most accessible entry point — best tutorial/blog + best starter repo]

### Choosing an Approach
[Decision guide based on use case, constraints]

## 6. Open Problems & Future Directions
- [Unsolved problem 1]
- [Research gap identified]

## 7. References
### Papers
- [Author et al. (Year). Title. arXiv:XXXX.XXXXX](url)

### Code
- [owner/repo](url) — description

### Blogs & Tutorials
- [Post Title](url) — Author, Date
```

## Writing Principles

| Principle | Application |
|-----------|-------------|
| **Audience-aware** | Define assumed background at top; define all jargon |
| **Evidence-backed** | Every claim cites a source |
| **Comparative** | Don't just describe — compare approaches |
| **Actionable** | Reader should know what to do next |
| **Concise** | Prefer tables and bullets over prose paragraphs |

## Length Guidelines

| Report Type | Target Length |
|-------------|--------------|
| Quick brief | 500-800 words |
| Standard report | 1500-2500 words |
| Deep survey | 3000-5000 words |

## Quality Checklist

Before finalizing, verify:
- [ ] Executive summary is self-contained (readable without rest)
- [ ] Every technical claim has a citation
- [ ] Comparison matrix covers all major approaches
- [ ] At least one actionable recommendation per section
- [ ] All URLs are working and point to correct sources
- [ ] Terminology table covers all domain-specific terms
- [ ] Open problems section identifies genuine gaps (not just future work from papers)

## Integration with Other Skills

This skill depends on outputs from:
1. `arxiv-search` — provides paper references
2. `github-codebase-search` — provides implementation details
3. `technical-blog-search` — provides accessible explanations
4. `information-combiner` — provides the synthesis this report is built on

If any upstream source is thin, note the gap explicitly in the report rather than omitting the section.

## Common Mistakes

- Writing the executive summary last without revising it — it should reflect the full report
- Omitting limitations — an honest report covers what methods don't solve
- Listing references without explaining relevance — every citation needs context
- Making the report a list of summaries — synthesize, don't just enumerate
