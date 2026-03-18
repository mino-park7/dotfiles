# Testing Strategy Reference

## Test Writing Principles

### Coverage
- Write tests for all new functionality
- Test both success and failure cases
- Verify all examples in README.md execute correctly

### Isolation
- Mock package resources when testing
- Use fixtures for setup and teardown
- Keep tests independent from each other

## Test Environment

### File System Safety
- Do not modify project files during test execution (e.g., `mkdocs.yml`)
- Use temporary directories for test outputs
- Clean up after tests complete

### Environment Detection
- Detect test environment to separate from production behavior
- Use environment variables or fixtures to identify test context
- Configure different behavior for test vs production

## Pytest Usage

### Framework Selection
- **ONLY use pytest or pytest plugins** - do NOT use the unittest module
- Leverage pytest's powerful features:
  - Fixtures for setup/teardown
  - Parametrization for multiple test cases
  - Markers for test organization
  - Plugins for extended functionality

### Test Organization
- All tests should be in `tests/` directory
- Be sure to create all necessary files and folders
- If creating files inside of `tests/` or `xsim/tests/`, be sure to make a `__init__.py` file if one does not exist
- Group related tests in the same file
- Use descriptive file names matching the module being tested

## Test Annotations and Documentation

### Type Annotations
- All tests should have typing annotations
- Import types conditionally for test fixtures:

```python
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from _pytest.capture import CaptureFixture
    from _pytest.fixtures import FixtureRequest
    from _pytest.logging import LogCaptureFixture
    from _pytest.monkeypatch import MonkeyPatch
    from pytest_mock.plugin import MockerFixture
```

### Docstrings
- All tests should contain docstrings
- Use Google-style docstrings for consistency
- Document:
  - What is being tested
  - Expected behavior
  - Any special setup or conditions

### Test Function Signatures
```python
def test_example(
    capsys: "CaptureFixture",
    request: "FixtureRequest",
    caplog: "LogCaptureFixture",
    monkeypatch: "MonkeyPatch",
    mocker: "MockerFixture",
) -> None:
    """Test description here.
    
    Args:
        capsys: Pytest fixture for capturing stdout/stderr
        request: Pytest fixture for request context
        caplog: Pytest fixture for capturing log messages
        monkeypatch: Pytest fixture for patching
        mocker: Pytest-mock fixture for mocking
    """
    pass
```

## Best Practices

### Test Structure
- Follow Arrange-Act-Assert pattern:
  1. **Arrange**: Set up test data and conditions
  2. **Act**: Execute the code being tested
  3. **Assert**: Verify the results

### Mocking
- Mock external dependencies (APIs, databases, file systems)
- Use `mocker` fixture from pytest-mock
- Mock at the appropriate level (function, class, module)
- Verify mock calls when testing interactions

### Assertions
- Use specific assertions (`assert x == y`, not just `assert x`)
- Include descriptive error messages
- Test edge cases and boundary conditions
- Verify error handling and exceptions

### Performance
- Keep tests fast
- Use mocks instead of real external services
- Parallelize test execution when possible
- Avoid unnecessary setup/teardown

