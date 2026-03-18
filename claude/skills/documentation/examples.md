# Documentation Examples

## README Examples

### Good README Example
```markdown
# Project Name

Brief description of what this project does.

## Installation

```bash
pip install project-name
```

## Quick Start

```python
from project import MainClass

# Basic usage
obj = MainClass()
result = obj.process(data)
```

## Features

- Feature 1: Description
- Feature 2: Description
- Feature 3: Description

## Documentation

Full documentation: https://docs.example.com

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md)

## License

MIT License
```

---

## Docstring Examples

### Bad: Missing information
```python
def process_data(data):
    """Process data."""
    return data.strip().lower()
```

### Good: Complete docstring
```python
def process_data(data: str) -> str:
    """Process input data by stripping whitespace and converting to lowercase.

    This function is useful for normalizing user input before validation.

    Args:
        data: Input string to process.

    Returns:
        Processed string with whitespace removed and converted to lowercase.

    Raises:
        TypeError: If data is not a string.

    Examples:
        >>> process_data("  Hello World  ")
        'hello world'
        >>> process_data("UPPERCASE")
        'uppercase'
    """
    if not isinstance(data, str):
        raise TypeError(f"Expected str, got {type(data)}")
    return data.strip().lower()
```

---

## Comment Examples

### Bad: Obvious comment
```python
# Increment i by 1
i += 1

# Check if user is not None
if user is not None:
    # Call the process method
    user.process()
```

### Good: Helpful comment
```python
# Use exponential backoff to avoid rate limiting
wait_time = 2 ** retry_count

# Workaround for bug in library v1.2.3 where None is returned
# instead of empty list. Remove when upgrading to v1.3.0
if result is None:
    result = []

# This algorithm uses dynamic programming to achieve O(n) complexity
# instead of the naive O(n²) approach
cache = {}
for item in items:
    if item in cache:
        continue
    cache[item] = expensive_computation(item)
```

---

## Class Documentation

### Good: Well-documented class
```python
class UserManager:
    """Manages user accounts and authentication.

    This class provides methods for creating, updating, and authenticating
    users. It handles password hashing and session management.

    Attributes:
        db: Database connection for user storage.
        hash_algo: Algorithm used for password hashing. Defaults to bcrypt.

    Examples:
        >>> manager = UserManager(db)
        >>> user = manager.create_user("john@example.com", "password123")
        >>> authenticated = manager.authenticate("john@example.com", "password123")
    """

    def __init__(self, db: Database, hash_algo: str = "bcrypt"):
        """Initialize UserManager.

        Args:
            db: Database connection for user storage.
            hash_algo: Password hashing algorithm. Defaults to "bcrypt".
        """
        self.db = db
        self.hash_algo = hash_algo

    def create_user(self, email: str, password: str) -> User:
        """Create a new user account.

        Args:
            email: User's email address.
            password: Plain text password (will be hashed).

        Returns:
            Created User object.

        Raises:
            ValueError: If email is invalid or already exists.
            ValueError: If password is too weak.
        """
        # Implementation...
```

---

## Deprecation Example

### Good: Clear deprecation notice
```python
import warnings

def old_api(data: dict) -> dict:
    """Process data using the old API.

    .. deprecated:: 2.0
        Use :func:`new_api` instead. This function will be removed in v3.0.

    Args:
        data: Input data dictionary.

    Returns:
        Processed data dictionary.
    """
    warnings.warn(
        "old_api is deprecated, use new_api instead",
        DeprecationWarning,
        stacklevel=2,
    )
    return new_api(data)
```

And in README:
```markdown
## Deprecated Features

### `old_api()` (Deprecated since v2.0)

**Removal:** Version 3.0

**Replacement:** Use `new_api()` instead.

**Migration Guide:**
```python
# Old code
result = old_api({"key": "value"})

# New code
result = new_api({"key": "value"})
```

The new API provides better performance and additional features.
```
