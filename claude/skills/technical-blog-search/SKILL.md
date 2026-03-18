---
name: technical-blog-search
description: Use when searching for technical blog posts, tutorials, or explanatory articles about a research or engineering topic. Triggers when user asks to find blog posts, tutorials, write-ups, or practical explanations beyond academic papers.
---

# Technical Blog Search

Search for high-quality technical blog posts and tutorials via web search.

## Priority Sources

Search these sources first — they have consistently high technical quality:

| Source | URL Pattern | Best For |
|--------|-------------|----------|
| Distill.pub | `distill.pub` | Deep ML explanations |
| Lil'Log | `lilianweng.github.io` | ML survey posts |
| Hugging Face Blog | `huggingface.co/blog` | NLP/transformers |
| Google AI Blog | `ai.googleblog.com` | Google research |
| OpenAI Blog | `openai.com/blog` | OpenAI research |
| Papers With Code | `paperswithcode.com` | ML benchmarks |
| Towards Data Science | `towardsdatascience.com` | Practical ML |
| The Gradient | `thegradient.pub` | ML commentary |
| Sebastian Ruder | `ruder.io` | NLP deep dives |

## Search Queries

### Google Web Search Format
```
site:lilianweng.github.io [TOPIC]
site:distill.pub [TOPIC]
[TOPIC] tutorial explained site:towardsdatascience.com
[TOPIC] "how it works" -arxiv
[TOPIC] implementation guide python
```

### General Search Patterns
```
[TOPIC] explained intuitively
[TOPIC] from scratch tutorial
[TOPIC] deep dive blog post
[TOPIC] visual explanation
```

## Evaluation Criteria

| Signal | What to Check |
|--------|---------------|
| Author credentials | Researcher/engineer at known org |
| Depth | Technical detail, math, code examples |
| Recency | Publication date (prefer <2 years) |
| Engagement | Comments, shares, citations |
| Code samples | Runnable examples increase quality |

## Output Format

```markdown
## Technical Blogs: [Topic]

### Blog 1: [Post Title](URL)
- **Source:** [Site Name] | **Author:** [Name] | **Date:** [Year-Month]
- **Summary:** [2-3 sentences on what it covers]
- **Key insights:** [Main takeaways, unique perspective]
- **Relevance:** [Why useful for the task]

### Blog 2: ...
```

## Search Tips

- Start with known high-quality sources before general search
- Search for "[PAPER TITLE] explained" to find blog summaries of key papers
- Look for "annotated" versions (e.g., "The Annotated Transformer")
- Check author's other posts once you find a good author
- Reddit r/MachineLearning and r/learnmachinelearning often link quality posts

## Common Mistakes

- Trusting low-quality Medium posts with no technical depth
- Missing Distill.pub/Lil'Log — these are often the best explanations
- Not checking post date — outdated tutorials can mislead
