# Code Quality Examples

## Linter Compliance

### Bad: Unused imports and variables
```python
import os  # Not used
import sys  # Not used
from typing import List, Dict, Optional  # List, Dict not used

def process_data(data):
    result = []  # Not used
    temp = "temp"  # Not used
    for item in data:
        print(item)
```

### Good: Only necessary imports
```python
from typing import Optional

def process_data(data: list[str]) -> None:
    for item in data:
        print(item)
```

---

### Bad: Deep nested conditionals
```python
def validate_user(user):
    if user:
        if user.is_active:
            if user.has_permission:
                if user.email_verified:
                    return True
                else:
                    return False
            else:
                return False
        else:
            return False
    else:
        return False
```

### Good: Early return pattern
```python
def validate_user(user: User | None) -> bool:
    if not user:
        return False
    if not user.is_active:
        return False
    if not user.has_permission:
        return False
    if not user.email_verified:
        return False
    return True
```

---

## Error Handling

### Bad: Vague error message
```python
def load_config(path):
    if not os.path.exists(path):
        raise ValueError("Invalid path")
    # ...
```

### Good: Clear and actionable error message
```python
def load_config(path: str) -> Config:
    if not os.path.exists(path):
        raise FileNotFoundError(
            f"Config file not found: {path}. "
            f"Create a config file or use --config to specify a different path. "
            f"Example: {path}.example"
        )
    # ...
```

---

### Bad: Using print
```python
def process_request(request):
    print(f"Processing request: {request.id}")
    try:
        result = do_work(request)
        print(f"Success: {result}")
    except Exception as e:
        print(f"Error: {e}")
```

### Good: Using logger
```python
import logging

logger = logging.getLogger(__name__)

def process_request(request: Request) -> Result:
    logger.info("Processing request", extra={"request_id": request.id})
    try:
        result = do_work(request)
        logger.info("Request completed", extra={"request_id": request.id, "result": result})
        return result
    except Exception as e:
        logger.error(
            "Request failed",
            extra={"request_id": request.id},
            exc_info=True,
        )
        raise
```

---

## Backward Compatibility

### Bad: Breaking API change
```python
# v1.0
def fetch_data(url, timeout=30):
    ...

# v2.0 - Breaking change!
def fetch_data(url, *, timeout=30, retry=3):
    ...
```

### Good: Gradual deprecation
```python
import warnings
from typing import Any

# v2.0 - Maintains compatibility
def fetch_data(
    url: str,
    timeout: int = 30,
    retry: int = 3,
    **kwargs: Any,
) -> Response:
    # Support old positional args while warning
    if kwargs:
        warnings.warn(
            "Passing extra kwargs is deprecated",
            DeprecationWarning,
            stacklevel=2,
        )
    ...
```
