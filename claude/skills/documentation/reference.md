# Documentation Reference

## README Management

### When to Update README
- Adding new features or functionality
- Changing public API
- Modifying installation process
- Updating project structure
- Adding/removing dependencies

### README Structure
1. **Title and Description**: What the project does
2. **Installation**: How to install
3. **Quick Start**: Basic usage example
4. **Features**: Main capabilities
5. **Documentation**: Links to detailed docs
6. **Contributing**: How to contribute
7. **License**: Project license

### Usage Examples
- Should be runnable
- Cover common use cases
- Show realistic scenarios
- Include expected output

### Diagrams
- Update when architecture changes
- Use consistent notation
- Keep diagrams simple
- Prefer text-based formats (mermaid, ASCII)

### Deprecation Notice
```markdown
## Deprecated Features

### `old_function()` (Deprecated since v2.0)
Use `new_function()` instead. Will be removed in v3.0.

**Migration:**
```python
# Old
result = old_function(data)

# New
result = new_function(data)
```
```

## Code Documentation

### Docstring Requirements
- All public functions
- All public classes
- All public methods
- Module-level docstrings

### What to Document
- **Purpose**: What does it do?
- **Parameters**: What inputs does it take?
- **Returns**: What does it return?
- **Raises**: What exceptions can it raise?
- **Examples**: How to use it?

### When to Add Comments
- Complex algorithms
- Non-obvious logic
- Performance considerations
- Workarounds for bugs
- TODOs and FIXMEs

### What NOT to Comment
- Obvious code
- Code that explains itself
- Redundant information

## Language Guidelines
- Use English for all documentation
- Use clear, simple language
- Avoid jargon when possible
- Define technical terms
