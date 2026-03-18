---
name: git-workflow
description: "Git workflow and commit standards. Reference when committing code or managing git operations."
---

# Git Workflow

Git workflow and commit standards. See [reference.md](./reference.md) and [examples.md](./examples.md) for details.

## Commit Standards
- Use Conventional Commits format
- Write commit messages in English
- Ensure pre-commit hooks pass
- Run unit tests locally before pushing
  - Integration tests are only ran on the CI workflows

## Commit Format
```
<type>(<scope>): <subject>

<body>

<footer>
```

## Common Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance
