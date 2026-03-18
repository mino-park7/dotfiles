---
name: cpp-style
description: "C++ coding style guide based on LLVM style. Reference when working with C++ files (*.hpp, *.cpp, *.h)."
---

# C++ Style Guide

C++ coding style guide based on LLVM style. See [reference.md](./reference.md) and [examples.md](./examples.md) for details.

## Core Rules

1. **Style Standard**: LLVM style + project modifications
2. **Automation Tools**: clang-format, clang-tidy, cpplint (check pre-commit config)
3. **Line Length**: Maximum 120 characters
4. **Indentation**: 2 spaces (no tabs)

## Naming Conventions

| Element | Style | Examples |
|---------|-------|----------|
| Functions | camelBack | `calculateTotal()`, `processData()` |
| Classes | CamelCase | `UserManager`, `PaymentProcessor` |
| Variables/Parameters | camelBack | `totalCount`, `userName` |
| Constants | UPPER_SNAKE_CASE | `MAX_RETRIES`, `DEFAULT_TIMEOUT` |
| Private Members | m_ prefix | `m_internalMember` |
| Macros | UPPER_SNAKE_CASE | `MAX_SIZE`, `ENABLE_FEATURE` |

## Header Guards

```cpp
// .h file
#ifndef PATH_TO_FILE_H_
#define PATH_TO_FILE_H_
// ...
#endif  // PATH_TO_FILE_H_

// .hpp file
#ifndef PATH_TO_FILE_HPP_
#define PATH_TO_FILE_HPP_
// ...
#endif  // PATH_TO_FILE_HPP_
```

## Include Order

1. Related header
2. System headers
3. Standard library
4. Third-party
5. Local headers

```cpp
#include "my_class.h"        // Related header

#include <sys/types.h>       // System header

#include <string>            // Standard library
#include <vector>

#include <pybind11/pybind11.h>  // Third-party

#include "local/utils.h"     // Local header
```

## Modern C++ Practices

- Use `nullptr` (not `NULL` or `0`)
- Use `auto` judiciously
- Actively use `const` and `constexpr`
- Use range-based for loops
- Prefer smart pointers (`std::unique_ptr`, `std::shared_ptr`)
- Use exception handling and `std::optional`
