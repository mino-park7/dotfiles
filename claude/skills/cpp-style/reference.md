# C++ Style Reference

## Style Standard

### Based on LLVM Style
The project follows LLVM coding style as a base with some project-specific modifications.

### Automation Tools
- **clang-format**: Automatic formatting
- **clang-tidy**: Static analysis
- **cpplint**: Additional style checks (header guards, etc.)

Check `.pre-commit-config.yaml` for configuration.

## Formatting Rules

### Line Length
- Maximum **120 characters**
- File header comments: **80 characters** limit

### Indentation
- **2 spaces** (no tabs)
- Continuation lines: **4 spaces**

## Header Guards

### Format
- `.h` files: `#ifndef PATH_TO_FILE_H_`
- `.hpp` files: `#ifndef PATH_TO_FILE_HPP_`

### Path Conversion Rules
Convert file path to uppercase and replace `/` and `.` with `_`.

Example: `include/hyperaccel/simulator/arch/base/cgmmu/base_cgmmu.h`
→ `HYPERACCEL_SIMULATOR_ARCH_BASE_CGMMU_BASE_CGMMU_H_`

## Include Organization

### Order
1. **Related header**: Header corresponding to current source file
2. **System headers**: OS-related headers (`<sys/...>`)
3. **Standard library**: C++ standard library (`<string>`, `<vector>`)
4. **Third-party**: External libraries (`<pybind11/...>`)
5. **Local headers**: Project internal headers

### Rules
- Local headers: Use double quotes (`"local_header.h"`)
- System/third-party: Use angle brackets (`<system_header.h>`)
- Add blank line between each group

## Braces and Formatting

### Brace Style
- **Attach style**: Opening brace on the same line

```cpp
if (condition) {
    // ...
}

void function() {
    // ...
}

class MyClass {
    // ...
};
```

### Empty Functions
Can be written on a single line if short:
```cpp
void emptyFunction() {}
```

## Pointers and References

### Alignment
- **Left-aligned** (LLVM style)
- Space between type and `*` or `&`

```cpp
int *ptr;      // Good
int* ptr;      // Bad

int &ref = x;  // Good
int& ref = x;  // Bad
```

## Comments

### File Header Comments
Required for all C++ files. Follow LLVM style.

```cpp
//===----------------------------------------------------------------------===//
//
// Part of the Hyperaccel Project
//
//===----------------------------------------------------------------------===//
///
/// \file
/// This file contains the declaration of the MyClass class.
///
//===----------------------------------------------------------------------===//
```

### Comment Styles
- Single line: `//`
- Multiple lines: `/* */`
- Documentation: `///` (Doxygen style)

## Modern C++ Practices

### Preferences
- Actively use C++17 features
- `auto`: When type is obvious or improves readability
- `const`, `constexpr`: Apply to immutable values
- `nullptr`: Instead of `NULL` or `0`
- Range-based for: When iterating containers
- Smart pointers: Instead of raw pointers

## Error Handling

### Using Exceptions
- Throw exceptions for exceptional conditions
- `std::optional`: Use for functions that may not return a value

## Memory Management

### RAII Pattern
Manage resources with constructors/destructors

### Prohibitions
- Minimize raw `new`/`delete`
- Check for null before dereferencing pointers

## Pybind11 Bindings

### Rules
- Proper type conversion and error handling
- Use `PYBIND11_MODULE` macro
- Write docstrings following Python conventions
- Ensure C++ exceptions properly propagate to Python
