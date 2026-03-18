---
name: code-quality
description: "Code quality management including linter compliance, dependency management, and error handling. Automatically applied to all code work."
---

# Code Quality Management

Core guidelines for code quality management. See [reference.md](./reference.md) and [examples.md](./examples.md) for details.

## Core Principles

1. **Linter Compliance**: Run linter via pre-commit, remove unused imports/variables
2. **Dependency Management**: Add dependencies to `pyproject.toml`, use `uv`
3. **Error Handling**: Clear error messages, use logger (not print)
4. **Backward Compatibility**: Maintain existing function signatures, mark deprecations

## Quick Reference

### Linter Compliance
- Remove unused imports
- Remove unused variables
- Simplify nested conditionals
- Apply Google coding conventions
- **Always run pre-commit before committing**

### Dependency Management
- Add new dependencies to `pyproject.toml`
- Specify version constraints
- Document why dependencies are needed
- Use `uv` to add dependencies

### Error Handling
- Provide actionable error messages
- Show available options when validation fails
- Include context in logging
- Use `logger` instead of `print`

### Backward Compatibility
- Maintain existing function signatures
- Clearly mark deprecated functions
- Provide migration path when breaking changes are necessary
