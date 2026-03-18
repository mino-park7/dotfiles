# Development Principles Reference

## Code Quality

### Single Responsibility Principle (SRP)
Functions and classes should have only one responsibility.

**Checklist:**
- Is the function over 20 lines? → Consider splitting
- Does the function name contain "and"? → Needs splitting
- Does it handle multiple levels of abstraction? → Needs splitting

### Remove Duplicate Code
Follow the DRY (Don't Repeat Yourself) principle.

**Guidelines:**
- If repeated 3 times, consider abstraction
- Avoid premature abstraction
- Accidentally similar code is not duplication

### Naming Rules
- **Variables**: Noun or noun phrase (`userCount`, `activeUsers`)
- **Functions**: Verb or verb phrase (`calculateTotal`, `validateInput`)
- **Booleans**: is/has/can prefix (`isValid`, `hasPermission`)
- **No abbreviations**: Use clear full words

### Language Rules
- **Code comments**: English
- **Commit messages**: English, Conventional Commits format
- **Documentation**: Follow project conventions

## Object-Oriented Design

### Design Pattern Guidelines

| Pattern | When to Use |
|---------|-------------|
| Strategy | Need to swap algorithms at runtime |
| Factory | Object creation logic is complex or varied |
| Observer | Need to notify multiple objects of state changes |
| Decorator | Need to add functionality to objects dynamically |

### Composition vs Inheritance
- **Inheritance**: Only for "is-a" relationships
- **Composition**: For "has-a" relationships (most cases)

### Separation of Concerns
Each module/class should handle one concern:
- **Data Loading**: Read from files/DB
- **Validation**: Verify data validity
- **Business Logic**: Core processing
- **File I/O**: Save results

## Project and Package Structure

### Module Structure
```
project/
├── compiler/
│   ├── __init__.py      # Public API
│   ├── core/
│   ├── data/            # Module-specific data
│   └── docs/            # Module-specific docs
├── simulator/
│   ├── __init__.py
│   └── ...
└── shared/              # Common utilities
    └── __init__.py
```

### Module Principles
1. **Self-contained**: Each module operates independently
2. **Explicit dependencies**: Dependencies clearly declared
3. **No circular dependencies**: No circular references between modules
4. **Clean API**: Define public interface via `__init__.py`

### Public API Design
```python
# module/__init__.py
from module.core import MainClass
from module.utils import helper_function

__all__ = ["MainClass", "helper_function"]
```

### Resource Placement
- Module data: `module_name/data/`
- Module docs: `module_name/docs/`
- No external config directory options
