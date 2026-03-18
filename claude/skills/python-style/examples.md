# Python Style Examples

## Type Annotations

### Bad: No type hints
```python
def calculate_total(items):
    total = 0
    for item in items:
        total += item['price'] * item['quantity']
    return total
```

### Good: Complete type hints
```python
def calculate_total(items: list[dict[str, int]]) -> int:
    """Calculate total price for items.

    Args:
        items: List of items with 'price' and 'quantity' keys.

    Returns:
        Total price as integer.
    """
    total = 0
    for item in items:
        total += item['price'] * item['quantity']
    return total
```

### Better: Using TypedDict
```python
from typing import TypedDict

class Item(TypedDict):
    price: int
    quantity: int

def calculate_total(items: list[Item]) -> int:
    """Calculate total price for items.

    Args:
        items: List of items with price and quantity.

    Returns:
        Total price as integer.
    """
    return sum(item['price'] * item['quantity'] for item in items)
```

---

## Docstrings

### Bad: Missing or incomplete docstring
```python
def process_user(user_id, update_data=None):
    # Get user
    user = get_user(user_id)
    if update_data:
        user.update(update_data)
    return user
```

### Good: Complete Google-style docstring
```python
def process_user(
    user_id: int,
    update_data: dict[str, str] | None = None,
) -> dict[str, str]:
    """Process user data with optional updates.

    Retrieves user data from database and optionally applies updates
    before returning the user information.

    Args:
        user_id: Unique identifier for the user.
        update_data: Optional dictionary of fields to update.
            Defaults to None.

    Returns:
        Dictionary containing user data with all fields.

    Raises:
        UserNotFoundError: If user_id doesn't exist in database.
        ValidationError: If update_data contains invalid fields.

    Examples:
        >>> process_user(123)
        {'id': 123, 'name': 'John', 'email': 'john@example.com'}

        >>> process_user(123, {'name': 'Jane'})
        {'id': 123, 'name': 'Jane', 'email': 'john@example.com'}
    """
    user = get_user(user_id)
    if update_data:
        user.update(update_data)
    return user
```

---

## Class Documentation

### Bad: Missing docstrings
```python
class DataProcessor:
    def __init__(self, config):
        self.config = config
        self.cache = {}

    def process(self, data):
        if data in self.cache:
            return self.cache[data]
        result = self._transform(data)
        self.cache[data] = result
        return result

    def _transform(self, data):
        return data.upper()
```

### Good: Complete documentation
```python
class DataProcessor:
    """Processes and caches data transformations.

    This class provides data transformation with built-in caching
    to improve performance for repeated operations.

    Attributes:
        config: Configuration dictionary for processing.
        cache: Internal cache for processed results.

    Examples:
        >>> processor = DataProcessor({'max_cache': 100})
        >>> result = processor.process("hello")
        >>> result
        'HELLO'
    """

    def __init__(self, config: dict[str, int]):
        """Initialize DataProcessor.

        Args:
            config: Configuration with 'max_cache' key for cache size limit.
        """
        self.config = config
        self.cache: dict[str, str] = {}

    def process(self, data: str) -> str:
        """Process data with caching.

        Args:
            data: Input string to process.

        Returns:
            Processed string (uppercase).
        """
        if data in self.cache:
            return self.cache[data]

        result = self._transform(data)
        self.cache[data] = result
        return result

    def _transform(self, data: str) -> str:
        """Transform data to uppercase.

        Args:
            data: Input string.

        Returns:
            Uppercase version of input.
        """
        return data.upper()
```

---

## Import Organization

### Bad: Disorganized imports
```python
from mypackage.utils import helper
import sys
from typing import List
import os
import numpy as np
from mypackage.models import User
from collections import defaultdict
```

### Good: Organized imports
```python
# Standard library
import os
import sys
from collections import defaultdict
from typing import List

# Third-party
import numpy as np

# Local
from mypackage.models import User
from mypackage.utils import helper
```

---

## Modern Type Hints (Python 3.10+)

### Old Style (Python 3.8-3.9)
```python
from typing import Optional, Union, List, Dict

def process(
    data: Optional[str],
    items: List[str],
    mapping: Dict[str, int],
) -> Union[str, int]:
    ...
```

### New Style (Python 3.10+)
```python
def process(
    data: str | None,
    items: list[str],
    mapping: dict[str, int],
) -> str | int:
    ...
```

---

## Complex Type Examples

### Using Protocol for Duck Typing
```python
from typing import Protocol

class Drawable(Protocol):
    """Protocol for objects that can be drawn."""

    def draw(self) -> None:
        """Draw the object."""
        ...

class Circle:
    """Circle that implements Drawable protocol."""

    def draw(self) -> None:
        """Draw the circle."""
        print("Drawing circle")

def render(obj: Drawable) -> None:
    """Render any drawable object.

    Args:
        obj: Object implementing Drawable protocol.
    """
    obj.draw()

# Works with any object that has draw() method
render(Circle())
```

### Using TypeVar for Generic Functions
```python
from typing import TypeVar, Sequence

T = TypeVar('T')

def first(items: Sequence[T]) -> T | None:
    """Get first item from sequence.

    Args:
        items: Sequence of items of any type.

    Returns:
        First item or None if sequence is empty.

    Examples:
        >>> first([1, 2, 3])
        1
        >>> first(["a", "b"])
        'a'
        >>> first([])
        None
    """
    return items[0] if items else None
```

---

## Naming Conventions

### Good Examples
```python
# Module: user_manager.py

# Constants
MAX_LOGIN_ATTEMPTS = 3
DEFAULT_TIMEOUT = 30

# Class
class UserManager:
    """Manage user accounts."""

    # Class variable
    active_sessions = 0

    def __init__(self):
        # Private attribute
        self._cache = {}

        # Public attribute
        self.session_timeout = DEFAULT_TIMEOUT

    # Public method
    def create_user(self, username: str) -> User:
        """Create a new user."""
        ...

    # Private method
    def _validate_username(self, username: str) -> bool:
        """Validate username format."""
        ...

    # Protected method (single underscore)
    def _update_cache(self, key: str, value: str) -> None:
        """Update internal cache."""
        self._cache[key] = value

# Function
def calculate_user_score(activities: list[Activity]) -> float:
    """Calculate user score from activities."""
    ...
```
