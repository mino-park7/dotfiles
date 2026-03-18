# C++ Style Examples

## Header Guards

### Bad
```cpp
// my_class.h
#pragma once  // Non-standard

class MyClass {};
```

### Good
```cpp
// include/hyperaccel/core/my_class.h
#ifndef HYPERACCEL_CORE_MY_CLASS_H_
#define HYPERACCEL_CORE_MY_CLASS_H_

class MyClass {};

#endif  // HYPERACCEL_CORE_MY_CLASS_H_
```

---

## Naming Conventions

### Bad
```cpp
class user_manager {          // Classes should be CamelCase
    int TotalCount;           // Variables should be camelBack
    void ProcessData();       // Functions should be camelBack
    int internal_member;      // Private members need m_ prefix
};

const int max_retries = 3;    // Constants should be UPPER_SNAKE_CASE
```

### Good
```cpp
class UserManager {
public:
    void processData();

private:
    int m_totalCount;
    int m_internalMember;
};

const int MAX_RETRIES = 3;
constexpr int DEFAULT_TIMEOUT = 30;
```

---

## Include Organization

### Bad
```cpp
#include "local_utils.h"
#include <vector>
#include "my_class.h"
#include <pybind11/pybind11.h>
#include <string>
#include <sys/types.h>
```

### Good
```cpp
#include "my_class.h"

#include <sys/types.h>

#include <string>
#include <vector>

#include <pybind11/pybind11.h>

#include "local_utils.h"
```

---

## Brace Style

### Bad
```cpp
void function()
{                           // Opening brace should be on same line
    if (condition)
    {
        // ...
    }
}
```

### Good
```cpp
void function() {
    if (condition) {
        // ...
    }
}
```

---

## Pointers and References

### Bad
```cpp
int* ptr;           // Attached to type
int& ref = x;       // Attached to type
```

### Good (LLVM Style)
```cpp
int *ptr;           // Attached to variable
int &ref = x;       // Attached to variable
```

---

## Modern C++

### Bad
```cpp
void process(std::vector<int>* data) {
    if (data == NULL) {                     // Using NULL
        return;
    }
    for (int i = 0; i < data->size(); i++) {  // C-style for loop
        int* item = new int((*data)[i]);      // raw new
        // ... use item
        delete item;                          // raw delete
    }
}
```

### Good
```cpp
void process(const std::vector<int> &data) {
    for (const auto &item : data) {           // range-based for
        auto ptr = std::make_unique<int>(item);  // smart pointer
        // ... use ptr
    }  // Automatic cleanup
}
```

---

## File Header Comment

### Bad
```cpp
// MyClass implementation
// Author: someone

class MyClass {};
```

### Good
```cpp
//===----------------------------------------------------------------------===//
//
// Part of the Hyperaccel Project
//
//===----------------------------------------------------------------------===//
///
/// \file
/// This file contains the declaration of the MyClass class, which handles
/// data processing and validation for the core module.
///
//===----------------------------------------------------------------------===//

class MyClass {};
```

---

## Error Handling

### Bad
```cpp
int getValue(int index) {
    if (index < 0) {
        return -1;  // Magic number for error
    }
    return m_data[index];
}
```

### Good
```cpp
std::optional<int> getValue(int index) const {
    if (index < 0 || index >= static_cast<int>(m_data.size())) {
        return std::nullopt;
    }
    return m_data[index];
}

// Or using exceptions
int getValue(int index) const {
    if (index < 0 || index >= static_cast<int>(m_data.size())) {
        throw std::out_of_range("Index out of bounds: " + std::to_string(index));
    }
    return m_data[index];
}
```

---

## Pybind11 Bindings

### Good
```cpp
#include <pybind11/pybind11.h>

namespace py = pybind11;

PYBIND11_MODULE(mymodule, m) {
    m.doc() = "My module docstring";

    py::class_<MyClass>(m, "MyClass")
        .def(py::init<>())
        .def("process", &MyClass::process,
             "Process data and return results",
             py::arg("data"))
        .def_property_readonly("value", &MyClass::getValue,
                               "Get the current value");
}
```
