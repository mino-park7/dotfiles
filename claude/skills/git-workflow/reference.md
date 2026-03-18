# Git Workflow Reference

## Conventional Commits

### Format
```
<type>(<scope>): <subject>

[optional body]

[optional footer]
```

### Type
- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation only
- **style**: Code style (formatting, missing semicolons, etc.)
- **refactor**: Code refactoring (no functional changes)
- **perf**: Performance improvements
- **test**: Adding or updating tests
- **build**: Build system changes
- **ci**: CI configuration changes
- **chore**: Other changes (maintenance, dependencies, etc.)

### Scope (optional)
Module or component affected:
- `compiler`
- `simulator`
- `api`
- `ui`

### Subject
- Use imperative mood ("add" not "added" or "adds")
- Don't capitalize first letter
- No period at the end
- Maximum 50 characters

### Body (optional)
- Explain what and why, not how
- Wrap at 72 characters
- Separate from subject with blank line

### Footer (optional)
- Breaking changes: `BREAKING CHANGE: description`
- Issue references: `Fixes #123`, `Closes #456`

## Pre-commit Hooks

### Setup
```bash
# Install pre-commit
pip install pre-commit

# Install hooks
pre-commit install

# Run manually
pre-commit run --all-files
```

### What Pre-commit Checks
- Linting (ruff, clang-format, etc.)
- Type checking
- Test execution
- File formatting
- Trailing whitespace
- Large file detection

## Testing Before Push

### Run Unit Tests
```bash
# Run all unit tests
pytest

# Run specific test file
pytest tests/test_module.py

# Run with coverage
pytest --cov=src
```

### Integration Tests
- Run on CI/CD only
- Too slow/complex for local development
- Triggered automatically on push/PR

## Branch Strategy

### Main Branches
- `main` or `master`: Production-ready code
- `develop`: Integration branch (if used)

### Feature Branches
- Format: `feature/description` or `feat/description`
- Example: `feature/add-user-auth`

### Bug Fix Branches
- Format: `fix/description`
- Example: `fix/login-validation`

### Work-in-Progress
- Mark with `WIP:` prefix in commit message
- Example: `WIP: add user authentication`

## Pull Request Guidelines

### Before Creating PR
- [ ] All tests pass locally
- [ ] Pre-commit hooks pass
- [ ] Code is reviewed personally
- [ ] Documentation updated
- [ ] Branch is up to date with base

### PR Description
- Clear title following Conventional Commits
- Summary of changes
- Related issue numbers
- Testing notes
- Screenshots (if UI changes)

### PR Size
- Keep PRs small and focused
- Aim for < 500 lines changed
- Split large features into multiple PRs
