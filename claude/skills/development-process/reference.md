# Development Process Reference

## Test-Driven Development (TDD)

### The TDD Cycle
1. **Red**: Write a failing test
2. **Green**: Write minimal code to make it pass
3. **Refactor**: Improve code while keeping tests green

### Benefits of TDD
- **Better design**: Writing tests first leads to more testable code
- **Clear requirements**: Tests document expected behavior
- **Confidence**: Refactor without fear of breaking functionality
- **Fast feedback**: Catch bugs immediately

### When to Write Tests
- **Always**: Before implementing new features
- **Bug fixes**: Write test that reproduces bug first
- **Refactoring**: Ensure existing tests pass
- **Edge cases**: Test boundary conditions

### Test Writing Tips
- One assertion per test (when possible)
- Test behavior, not implementation
- Use descriptive test names
- Keep tests simple and readable

## Refactoring Process

### Before Refactoring
1. **Run all tests**: Ensure current state is correct
2. **Understand the code**: Read and comprehend what it does
3. **Identify smell**: What needs to be improved?
4. **Plan approach**: How will you refactor it?

### During Refactoring
1. **Small steps**: Make one change at a time
2. **Run tests frequently**: After each small change
3. **Commit often**: Commit each successful refactoring step
4. **Stay focused**: Don't add features while refactoring

### After Refactoring
1. **All tests pass**: Verify functionality unchanged
2. **Code review**: Get feedback on changes
3. **Update docs**: Reflect any API changes
4. **Performance check**: Ensure no regression

### Common Refactoring Patterns
- Extract method/function
- Rename for clarity
- Remove duplication
- Simplify conditionals
- Extract constants

## Code Change Workflow

### Phase 1: Before Changes

#### Understand Current Structure
- Read existing code
- Understand data flow
- Identify dependencies
- Check architecture patterns

#### Check Existing Tests
- What's already tested?
- Are tests passing?
- Coverage gaps?

#### Review Related Code
- Similar implementations
- Common patterns used
- Existing utilities

#### Plan Changes
- What needs to change?
- Impact on other code?
- Breaking changes?
- Migration needed?

### Phase 2: During Development

#### Make Incremental Changes
- One logical change at a time
- Commit frequently
- Keep changes focused

#### Run Tests Frequently
```bash
# Run specific test
pytest tests/test_mymodule.py

# Run all tests
pytest

# Run with coverage
pytest --cov=mymodule
```

#### Fix Linter Errors Immediately
```bash
# Run linter
ruff check .

# Auto-fix
ruff check --fix .
```

#### Update Documentation Simultaneously
- Update docstrings
- Update README if API changed
- Update examples

#### Run Pre-commit Frequently
```bash
pre-commit run --all-files
```

### Phase 3: Before Completion

#### Checklist
- [ ] All tests pass
- [ ] No linter errors
- [ ] README examples work
- [ ] Imports are correct
- [ ] Documentation updated
- [ ] No breaking changes (or documented)
- [ ] Pre-commit hooks pass

#### Final Verification
```bash
# Run everything
pytest && ruff check . && pre-commit run --all-files
```
