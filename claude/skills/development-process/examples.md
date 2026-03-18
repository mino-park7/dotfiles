# Development Process Examples

## Test-Driven Development

### Example: Adding a Calculator Function

#### Step 1: Write failing test (Red)
```python
# tests/test_calculator.py
import pytest
from calculator import add

def test_add_two_positive_numbers():
    """Test adding two positive numbers."""
    assert add(2, 3) == 5

def test_add_negative_numbers():
    """Test adding negative numbers."""
    assert add(-2, -3) == -5

def test_add_zero():
    """Test adding with zero."""
    assert add(5, 0) == 5
```

#### Step 2: Write minimal code (Green)
```python
# calculator.py
def add(a: int, b: int) -> int:
    """Add two numbers together.

    Args:
        a: First number.
        b: Second number.

    Returns:
        Sum of a and b.
    """
    return a + b
```

#### Step 3: Refactor (if needed)
Tests pass, code is simple, no refactoring needed.

---

## Refactoring Process

### Example: Extract Method

#### Before: Long method with multiple responsibilities
```python
def process_order(order_id: int) -> dict:
    # Fetch order
    with open(f"orders/{order_id}.json") as f:
        order = json.load(f)

    # Calculate total
    total = 0
    for item in order["items"]:
        price = item["price"]
        quantity = item["quantity"]
        discount = item.get("discount", 0)
        total += (price * quantity) * (1 - discount / 100)

    # Apply taxes
    tax_rate = 0.08
    total_with_tax = total * (1 + tax_rate)

    # Save result
    result = {
        "order_id": order_id,
        "subtotal": total,
        "tax": total * tax_rate,
        "total": total_with_tax,
    }

    with open(f"processed/{order_id}.json", "w") as f:
        json.dump(result, f)

    return result
```

#### After: Extracted methods
```python
def load_order(order_id: int) -> dict:
    """Load order from file."""
    with open(f"orders/{order_id}.json") as f:
        return json.load(f)

def calculate_item_total(item: dict) -> float:
    """Calculate total for a single item."""
    price = item["price"]
    quantity = item["quantity"]
    discount = item.get("discount", 0)
    return (price * quantity) * (1 - discount / 100)

def calculate_subtotal(items: list[dict]) -> float:
    """Calculate subtotal for all items."""
    return sum(calculate_item_total(item) for item in items)

def apply_tax(amount: float, tax_rate: float = 0.08) -> dict:
    """Apply tax to amount.

    Returns:
        Dict with subtotal, tax, and total.
    """
    tax = amount * tax_rate
    return {
        "subtotal": amount,
        "tax": tax,
        "total": amount + tax,
    }

def save_result(order_id: int, result: dict) -> None:
    """Save processing result."""
    with open(f"processed/{order_id}.json", "w") as f:
        json.dump(result, f)

def process_order(order_id: int) -> dict:
    """Process order and return result."""
    order = load_order(order_id)
    subtotal = calculate_subtotal(order["items"])
    result = apply_tax(subtotal)
    result["order_id"] = order_id
    save_result(order_id, result)
    return result
```

---

## Code Change Workflow

### Example: Adding New Feature

#### Phase 1: Before Changes

```bash
# Understand current structure
grep -r "class User" .
git log --oneline src/user.py

# Check existing tests
pytest tests/test_user.py -v

# Review related code
cat src/user.py
cat src/auth.py
```

#### Phase 2: During Development

```python
# Step 1: Write test
def test_user_can_change_email():
    """Test that user can change their email."""
    user = User(name="John", email="old@example.com")
    user.change_email("new@example.com")
    assert user.email == "new@example.com"

# Step 2: Run test (should fail)
# pytest tests/test_user.py::test_user_can_change_email

# Step 3: Implement feature
class User:
    def change_email(self, new_email: str) -> None:
        """Change user's email address.

        Args:
            new_email: New email address.

        Raises:
            ValueError: If email format is invalid.
        """
        if "@" not in new_email:
            raise ValueError("Invalid email format")
        self.email = new_email

# Step 4: Run test again (should pass)
# pytest tests/test_user.py::test_user_can_change_email

# Step 5: Run all tests
# pytest

# Step 6: Fix linter errors
# ruff check --fix .

# Step 7: Commit
# git add .
# git commit -m "feat: add ability to change user email"
```

#### Phase 3: Before Completion

```bash
# Final checks
pytest                                 # All tests pass?
ruff check .                          # No linter errors?
python examples/user_example.py       # README examples work?
pre-commit run --all-files           # Pre-commit passes?

# All good? Push!
git push
```

---

## Incremental Development

### Bad: Big bang approach
```python
# Making many changes at once
# - Refactor 5 classes
# - Add 3 new features
# - Fix 2 bugs
# - Update documentation
# Result: Hard to debug if something breaks
```

### Good: Incremental steps
```python
# Step 1: Refactor one class
git commit -m "refactor: simplify UserManager"

# Step 2: Add one feature
git commit -m "feat: add email validation"

# Step 3: Fix one bug
git commit -m "fix: handle None in get_user"

# Step 4: Update docs
git commit -m "docs: update API documentation"

# Result: Each change is isolated and easy to debug
```
