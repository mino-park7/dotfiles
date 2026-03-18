---
name: python-style
description: "Python coding style guide including typing, docstrings, and code organization. Reference when working with Python files (*.py, *.pyi)."
---

# Python Style Guide

Python coding standards and best practices. See [reference.md](./reference.md) and [examples.md](./examples.md) for details.

## Type Annotations
- **Always add typing annotations** to each function or class
- Include return types when necessary
- Use type hints for all function parameters and return values

## Docstrings
- Use **Google style guide** for docstrings
- Docstrings are very important - add descriptive Google-style docstrings to all Python functions and classes
- Update existing docstrings if needed

### Required Docstring Sections

#### Args
- Include the type of each argument
- Include the default value of the argument (format: "Defaults to {default_value}")

#### Returns
- Include the type of the return value

#### Raises
- Include the type of the exception

## Code Organization
- Keep any existing comments in files
- Use clear, descriptive naming that reflects the purpose
- Break down large functions into smaller ones following the single responsibility principle

## Code Style Tools
- Use Ruff for Python code style consistency
- Run linter before committing (use pre-commit)
