# Code Quality Reference

## Linter Compliance

### Why It Matters
- Maintains consistent code style
- Detects potential bugs early
- Improves code review efficiency

### Detailed Rules

#### Remove Unused Code
- **imports**: Remove all unused import statements
- **variables**: Remove declared but unused variables
- **functions**: Consider removing uncalled private functions

#### Simplify Conditionals
- Convert nested conditionals (depth 3+) to early return patterns
- Extract complex conditions into well-named variables

#### Pre-commit Usage
```bash
# Install
pre-commit install

# Run manually
pre-commit run --all-files
```

## Dependency Management

### Dependency Addition Principles
1. Verify the dependency is truly necessary
2. Check maintenance status (recent updates, issue count)
3. Verify license compatibility

### pyproject.toml Structure
```toml
[project]
dependencies = [
    "pydantic>=2.0,<3.0",  # Version range
    "rich~=13.0",          # Compatible version
]

[project.optional-dependencies]
dev = [
    "pytest>=7.0",
    "ruff>=0.1.0",
]
```

### Using uv
```bash
# Add dependency
uv add pydantic

# Add dev dependency
uv add --dev pytest

# Sync
uv sync
```

## Error Handling

### Error Message Principles
1. **Specific**: Clearly state what went wrong
2. **Actionable**: Suggest how to fix it
3. **Contextual**: Include relevant values or state

### Logging Level Guide
- `DEBUG`: Detailed debugging information
- `INFO`: General execution information
- `WARNING`: Potential issues, but execution can continue
- `ERROR`: Error occurred, some functionality unavailable
- `CRITICAL`: Severe error, program termination needed

## Backward Compatibility

### API Change Checklist
- [ ] Can existing signature be maintained?
- [ ] Added deprecation warning?
- [ ] Written migration guide?
- [ ] Updated CHANGELOG?

### Deprecation Pattern
```python
import warnings
from typing import Any

def old_function(*args: Any, **kwargs: Any) -> Any:
    """Deprecated: Use new_function instead."""
    warnings.warn(
        "old_function is deprecated, use new_function instead",
        DeprecationWarning,
        stacklevel=2,
    )
    return new_function(*args, **kwargs)
```
