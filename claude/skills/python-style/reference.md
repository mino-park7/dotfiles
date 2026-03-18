# Python Style Reference

## Type Annotations

### When to Use Type Hints
- **Always**: All function parameters and return values
- **Class attributes**: When not obvious from context
- **Module-level variables**: When not obvious from context

### Modern Python Type Syntax
```python
# Use | for Union (Python 3.10+)
def process(data: str | None) -> dict | None:
    ...

# Use list, dict, set directly (Python 3.9+)
def analyze(items: list[str]) -> dict[str, int]:
    ...

# For Python 3.8, use typing module
from typing import Union, Dict, List

def process(data: Union[str, None]) -> Union[Dict, None]:
    ...
```

### Complex Types
```python
from typing import Callable, Protocol, TypeVar

# Callable
Handler = Callable[[str, int], bool]

# Protocol for structural typing
class Drawable(Protocol):
    def draw(self) -> None: ...

# TypeVar for generics
T = TypeVar('T')

def first(items: list[T]) -> T | None:
    return items[0] if items else None
```

### Type Aliases
```python
# Simple alias
UserId = int
UserName = str

# Complex alias
UserData = dict[str, str | int | list[str]]
```

## Google-Style Docstrings

### Function Docstring Template
```python
def function_name(param1: type1, param2: type2 = default) -> return_type:
    """Brief description of function.

    Longer description if needed. Explain what the function does,
    not how it does it.

    Args:
        param1: Description of param1. Type: type1.
        param2: Description of param2. Type: type2. Defaults to default.

    Returns:
        Description of return value. Type: return_type.

    Raises:
        ExceptionType: When this exception occurs.

    Examples:
        >>> function_name("test", 42)
        expected_result
    """
```

### Class Docstring Template
```python
class ClassName:
    """Brief description of class.

    Longer description if needed. Explain the class purpose and
    main responsibilities.

    Attributes:
        attr1: Description of attr1. Type: type1.
        attr2: Description of attr2. Type: type2.

    Examples:
        >>> obj = ClassName()
        >>> obj.method()
        result
    """

    def __init__(self, param1: type1):
        """Initialize ClassName.

        Args:
            param1: Description of param1.
        """
        self.attr1 = param1
```

### Module Docstring Template
```python
"""Brief module description.

Longer module description explaining what the module provides
and how to use it.

Typical usage example:

  from module import ClassName

  obj = ClassName()
  result = obj.method()
"""
```

## Code Organization

### Import Order
1. Standard library imports
2. Related third-party imports
3. Local application/library imports

```python
# Standard library
import os
import sys
from pathlib import Path

# Third-party
import numpy as np
import pandas as pd
from pydantic import BaseModel

# Local
from mypackage.module import MyClass
from mypackage.utils import helper_function
```

### Import Formatting
```python
# Good: Absolute imports
from mypackage.module import function

# Avoid: Relative imports (use sparingly)
from .module import function

# Good: Specific imports
from collections import defaultdict, Counter

# Avoid: Wildcard imports
from collections import *
```

## Ruff Configuration

### Common Ruff Checks
- Line length (default: 88)
- Import sorting
- Unused imports and variables
- Docstring presence
- Type annotation coverage

### Running Ruff
```bash
# Check for issues
ruff check .

# Auto-fix issues
ruff check --fix .

# Format code
ruff format .
```

## Naming Conventions

### Python PEP 8 Naming
- **Modules**: lowercase_with_underscores
- **Classes**: CapitalizedWords (PascalCase)
- **Functions**: lowercase_with_underscores
- **Variables**: lowercase_with_underscores
- **Constants**: UPPER_CASE_WITH_UNDERSCORES
- **Private**: _leading_underscore

### Examples
```python
# Module: user_manager.py

# Constant
MAX_RETRY_COUNT = 3

# Class
class UserManager:
    # Private attribute
    _instance = None

    # Public method
    def create_user(self, name: str) -> User:
        ...

    # Private method
    def _validate_name(self, name: str) -> bool:
        ...
```
