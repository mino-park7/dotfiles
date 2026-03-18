# Testing Strategy Examples

## Basic Test Structure

### Good
```python
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from pytest_mock.plugin import MockerFixture


def test_calculate_total() -> None:
    """Test that calculate_total returns correct sum.
    
    Verifies basic addition functionality with positive integers.
    """
    # Arrange
    items = [10, 20, 30]
    
    # Act
    result = calculate_total(items)
    
    # Assert
    assert result == 60
```

---

## Type Annotations for Fixtures

### Good
```python
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from _pytest.capture import CaptureFixture
    from _pytest.fixtures import FixtureRequest
    from _pytest.logging import LogCaptureFixture
    from _pytest.monkeypatch import MonkeyPatch
    from pytest_mock.plugin import MockerFixture


def test_with_fixtures(
    capsys: "CaptureFixture",
    caplog: "LogCaptureFixture",
    mocker: "MockerFixture",
) -> None:
    """Test using multiple pytest fixtures.
    
    Args:
        capsys: Captures stdout/stderr output
        caplog: Captures log messages
        mocker: Provides mocking functionality
    """
    # Test implementation
    pass
```

---

## Mocking External Dependencies

### Bad
```python
def test_fetch_data() -> None:
    """Test data fetching."""
    # This makes real network calls!
    result = fetch_data_from_api("https://api.example.com")
    assert result is not None
```

### Good
```python
def test_fetch_data(mocker: "MockerFixture") -> None:
    """Test data fetching with mocked API.
    
    Args:
        mocker: Pytest-mock fixture for mocking
    """
    # Arrange
    mock_response = {"data": "test"}
    mocker.patch("requests.get", return_value=mock_response)
    
    # Act
    result = fetch_data_from_api("https://api.example.com")
    
    # Assert
    assert result == mock_response
```

---

## Testing Exceptions

### Good
```python
import pytest


def test_invalid_input_raises_error() -> None:
    """Test that invalid input raises ValueError.
    
    Verifies proper error handling for negative values.
    """
    with pytest.raises(ValueError, match="Value must be positive"):
        calculate_total([-1, 2, 3])
```

---

## Using Temporary Directories

### Bad
```python
def test_write_config() -> None:
    """Test config writing."""
    # Modifies project files!
    write_config("mkdocs.yml", {"site_name": "Test"})
    assert os.path.exists("mkdocs.yml")
```

### Good
```python
from pathlib import Path


def test_write_config(tmp_path: Path) -> None:
    """Test config writing using temporary directory.
    
    Args:
        tmp_path: Pytest fixture providing temporary directory
    """
    # Arrange
    config_file = tmp_path / "mkdocs.yml"
    config_data = {"site_name": "Test"}
    
    # Act
    write_config(config_file, config_data)
    
    # Assert
    assert config_file.exists()
    assert config_file.read_text() == "site_name: Test\n"
```

---

## Parametrized Tests

### Good
```python
import pytest


@pytest.mark.parametrize(
    "input_value,expected",
    [
        (0, 0),
        (1, 1),
        (5, 120),
        (10, 3628800),
    ],
)
def test_factorial(input_value: int, expected: int) -> None:
    """Test factorial calculation with multiple inputs.
    
    Args:
        input_value: Input number for factorial
        expected: Expected factorial result
    """
    result = factorial(input_value)
    assert result == expected
```

---

## Testing with Fixtures

### Good
```python
import pytest
from pathlib import Path


@pytest.fixture
def sample_data() -> dict[str, str]:
    """Provide sample data for tests.
    
    Returns:
        Dictionary with sample test data
    """
    return {"name": "Test User", "email": "test@example.com"}


def test_process_user_data(sample_data: dict[str, str]) -> None:
    """Test user data processing with fixture.
    
    Args:
        sample_data: Sample user data from fixture
    """
    result = process_user(sample_data)
    assert result["name"] == "Test User"
    assert result["email"] == "test@example.com"
```

---

## Success and Failure Cases

### Good
```python
def test_divide_success() -> None:
    """Test division with valid inputs."""
    result = divide(10, 2)
    assert result == 5.0


def test_divide_by_zero() -> None:
    """Test division by zero raises appropriate error."""
    with pytest.raises(ZeroDivisionError):
        divide(10, 0)


def test_divide_with_floats() -> None:
    """Test division with float inputs."""
    result = divide(10.5, 2.0)
    assert result == pytest.approx(5.25)
```

---

## Monkeypatching

### Good
```python
def test_with_environment_variable(monkeypatch: "MonkeyPatch") -> None:
    """Test behavior with environment variable set.
    
    Args:
        monkeypatch: Pytest fixture for modifying environment
    """
    # Arrange
    monkeypatch.setenv("TEST_MODE", "true")
    
    # Act
    result = get_mode()
    
    # Assert
    assert result == "test"
```

