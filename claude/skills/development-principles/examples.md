# Development Principles Examples

## Single Responsibility Principle

### Bad: Function with multiple responsibilities
```python
def process_user_data(user_id: int) -> dict:
    # 1. Data loading
    with open(f"users/{user_id}.json") as f:
        data = json.load(f)

    # 2. Validation
    if not data.get("email"):
        raise ValueError("Email required")
    if not data.get("name"):
        raise ValueError("Name required")

    # 3. Transformation
    data["full_name"] = f"{data['first_name']} {data['last_name']}"
    data["email_domain"] = data["email"].split("@")[1]

    # 4. Saving
    with open(f"processed/{user_id}.json", "w") as f:
        json.dump(data, f)

    return data
```

### Good: Separated responsibilities
```python
def load_user_data(user_id: int) -> dict:
    """Load user data from file."""
    with open(f"users/{user_id}.json") as f:
        return json.load(f)

def validate_user_data(data: dict) -> None:
    """Validate required user fields."""
    required = ["email", "name"]
    for field in required:
        if not data.get(field):
            raise ValueError(f"{field.capitalize()} required")

def transform_user_data(data: dict) -> dict:
    """Transform user data with computed fields."""
    return {
        **data,
        "full_name": f"{data['first_name']} {data['last_name']}",
        "email_domain": data["email"].split("@")[1],
    }

def save_user_data(user_id: int, data: dict) -> None:
    """Save processed user data."""
    with open(f"processed/{user_id}.json", "w") as f:
        json.dump(data, f)

def process_user_data(user_id: int) -> dict:
    """Process user data: load, validate, transform, save."""
    data = load_user_data(user_id)
    validate_user_data(data)
    data = transform_user_data(data)
    save_user_data(user_id, data)
    return data
```

---

## Composition over Inheritance

### Bad: Deep inheritance hierarchy
```python
class Animal:
    def eat(self): ...

class Mammal(Animal):
    def give_birth(self): ...

class Dog(Mammal):
    def bark(self): ...

class SwimmingDog(Dog):
    def swim(self): ...

class FlyingDog(Dog):  # Problem: What about dogs that swim AND fly?
    def fly(self): ...
```

### Good: Using composition
```python
from typing import Protocol

class Swimmer(Protocol):
    def swim(self) -> None: ...

class Flyer(Protocol):
    def fly(self) -> None: ...

class SwimmingAbility:
    def swim(self) -> None:
        print("Swimming...")

class FlyingAbility:
    def fly(self) -> None:
        print("Flying...")

class Dog:
    def __init__(
        self,
        swimmer: Swimmer | None = None,
        flyer: Flyer | None = None,
    ):
        self.swimmer = swimmer
        self.flyer = flyer

    def bark(self) -> None:
        print("Woof!")

    def swim(self) -> None:
        if self.swimmer:
            self.swimmer.swim()

    def fly(self) -> None:
        if self.flyer:
            self.flyer.fly()

# Now we can have dogs that swim AND fly!
super_dog = Dog(
    swimmer=SwimmingAbility(),
    flyer=FlyingAbility(),
)
```

---

## Design Patterns

### Strategy Pattern
```python
from abc import ABC, abstractmethod
from typing import Protocol

class CompressionStrategy(Protocol):
    def compress(self, data: bytes) -> bytes: ...

class GzipCompression:
    def compress(self, data: bytes) -> bytes:
        import gzip
        return gzip.compress(data)

class LzmaCompression:
    def compress(self, data: bytes) -> bytes:
        import lzma
        return lzma.compress(data)

class FileProcessor:
    def __init__(self, compression: CompressionStrategy):
        self.compression = compression

    def process(self, data: bytes) -> bytes:
        return self.compression.compress(data)

# Usage
processor = FileProcessor(GzipCompression())
result = processor.process(b"data")

# Change strategy at runtime
processor.compression = LzmaCompression()
result = processor.process(b"data")
```

---

## Module Structure

### Bad: Flat structure
```
project/
├── main.py
├── utils.py
├── helpers.py
├── constants.py
├── db.py
├── api.py
├── models.py
└── ... (all files at root)
```

### Good: Logical module structure
```
project/
├── compiler/
│   ├── __init__.py
│   ├── core/
│   │   ├── __init__.py
│   │   ├── lexer.py
│   │   └── parser.py
│   ├── data/
│   │   └── grammar.json
│   └── tests/
│       └── test_parser.py
├── simulator/
│   ├── __init__.py
│   ├── engine/
│   │   ├── __init__.py
│   │   └── runner.py
│   └── data/
│       └── configs/
└── shared/
    ├── __init__.py
    ├── logging.py
    └── config.py
```

### Public API Definition

```python
# compiler/__init__.py
"""Compiler module for processing source code."""

from compiler.core.lexer import Lexer
from compiler.core.parser import Parser

__all__ = ["Lexer", "Parser"]
```

```python
# Usage
from compiler import Lexer, Parser  # Clean import

lexer = Lexer()
parser = Parser()
```

---

## Naming

### Bad
```python
def proc(d):
    t = 0
    for i in d:
        t += i
    return t

x = proc([1, 2, 3])
```

### Good
```python
def calculate_sum(numbers: list[int]) -> int:
    total = 0
    for number in numbers:
        total += number
    return total

total_score = calculate_sum([1, 2, 3])
```
