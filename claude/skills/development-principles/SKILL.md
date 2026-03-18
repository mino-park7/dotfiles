---
name: development-principles
description: "Core development principles for code quality, object-oriented design, and package structure. Automatically applied to all development work."
---

# Development Principles

Core principles to follow during development. See [reference.md](./reference.md) and [examples.md](./examples.md) for details.

## Core Principles

### Code Quality
- Break down large functions into smaller ones following the single responsibility principle
- Remove duplicate code; use more generic solutions when available
- Use clear, descriptive naming that reflects the purpose
- Write code comments in English
- Write commit messages in English using Conventional Commits format

### Object-Oriented Design
- Apply appropriate design patterns for extensible functionality (Strategy, Factory, etc.)
- Prefer composition over inheritance
- Separate concerns: data loading, validation, generation, file I/O
- Organize related code into logically grouped directories/modules

### Project and Package Structure
- Organize related code into dedicated module directories at the repository root (e.g., `compiler/`, `simulator/`, `model_runtime/`)
- Each module should be self-contained with its own structure and dependencies
- Provide clean public APIs through `__init__.py` for Python modules
- Place module-specific data and resources within the module directory (e.g., `module_name/data/`, `module_name/docs/`)
- Do not provide external config directory options (use module-internal only)
- Share common utilities and code through well-defined interfaces, avoiding circular dependencies between modules
