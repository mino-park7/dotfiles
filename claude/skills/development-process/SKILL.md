---
name: development-process
description: "Development workflow including TDD, refactoring process, and code change workflow. Automatically applied to all development work."
---

# Development Process

Development workflow guidelines. See [reference.md](./reference.md) and [examples.md](./examples.md) for details.

## Core Processes

### Test-Driven Development (TDD)
- **Write tests before implementing features**
- Clarify requirements and interfaces while writing tests
- Run tests frequently during implementation to get feedback
- Write tests for all new functionality

### Refactoring Process
1. Run all tests before starting to confirm current state
2. Make incremental changes in small units
3. Run tests after each change
4. Update imports and references
5. Update tests if needed
6. Update documentation
7. Ensure all tests pass before completion

### Code Change Workflow
1. **Before changes**: Understand current structure, check existing tests, review related code, plan changes
2. **During development**: Make incremental changes, run tests frequently, fix linter errors immediately, update documentation simultaneously, run pre-commit frequently
3. **Before completion**: Run all tests, check linter (use pre-commit), verify README examples, check imports
