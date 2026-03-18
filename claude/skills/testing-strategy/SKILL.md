---
name: testing-strategy
description: "Testing principles and strategies for writing and running tests. Reference when working with test files."
---

# Testing Strategy

Testing principles and strategies for writing and running tests. See [reference.md](./reference.md) and [examples.md](./examples.md) for details.

## Core Principles
- Write tests for all new functionality
- Test both success and failure cases
- Verify all examples in README.md execute correctly
- Mock package resources when testing

## Pytest Usage
- **ONLY use pytest or pytest plugins** - do NOT use the unittest module
- All tests should have typing annotations
- All tests should be in `tests/` directory
- All tests should be fully annotated and contain docstrings

## Test Environment
- Do not modify project files during test execution (e.g., `mkdocs.yml`)
- Use temporary directories for test outputs
- Detect test environment to separate from production behavior

