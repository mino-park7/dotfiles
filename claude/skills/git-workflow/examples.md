# Git Workflow Examples

## Commit Message Examples

### Good Commit Messages

#### Feature Addition
```
feat(auth): add email verification

Implement email verification for new user registrations.
Users will receive a verification link via email that expires
after 24 hours.

Closes #123
```

#### Bug Fix
```
fix(api): handle null response from database

Previously, the API would crash when the database returned null.
Now it properly handles this case and returns a 404 status code.

Fixes #456
```

#### Documentation
```
docs(readme): update installation instructions

Add instructions for Python 3.12 and update dependency list.
```

#### Refactoring
```
refactor(user): extract validation logic

Move user validation logic to separate validator class for better
testability and reusability.
```

#### Breaking Change
```
feat(api)!: change response format

BREAKING CHANGE: API responses now use camelCase instead of
snake_case for field names.

Migration guide:
- Update clients to use camelCase field names
- Old: {"user_name": "john"}
- New: {"userName": "john"}
```

### Bad Commit Messages

```
fix stuff

updated code

WIP

asdf

fix bug

changes

final commit

THIS SHOULD WORK NOW
```

---

## Pre-commit Usage

### Initial Setup
```bash
# Install
pip install pre-commit

# Install git hooks
pre-commit install

# Test configuration
pre-commit run --all-files
```

### Daily Usage
```bash
# Hooks run automatically on commit
git add .
git commit -m "feat: add new feature"
# Pre-commit runs automatically

# If hooks fail
# Fix the issues, then:
git add .
git commit -m "feat: add new feature"
```

### Skip Hooks (Use Sparingly)
```bash
# Only when absolutely necessary
git commit --no-verify -m "fix: urgent hotfix"
```

---

## Branch Workflow

### Creating Feature Branch
```bash
# Create and switch to new branch
git checkout -b feature/user-authentication

# Make changes
# ...

# Commit changes
git add .
git commit -m "feat(auth): add user authentication"

# Push to remote
git push -u origin feature/user-authentication
```

### Updating Branch with Latest Changes
```bash
# Switch to main branch
git checkout main

# Pull latest changes
git pull origin main

# Switch back to feature branch
git checkout feature/user-authentication

# Rebase on main
git rebase main

# If conflicts, resolve them and:
git rebase --continue

# Force push (if already pushed)
git push --force-with-lease
```

---

## Pull Request Workflow

### Step 1: Prepare Branch
```bash
# Ensure all tests pass
pytest

# Ensure linter passes
ruff check .

# Ensure pre-commit passes
pre-commit run --all-files

# Push to remote
git push origin feature/user-authentication
```

### Step 2: Create PR

**Title:**
```
feat(auth): add user authentication system
```

**Description:**
```markdown
## Summary
Implements user authentication with email/password and JWT tokens.

## Changes
- Add User model with password hashing
- Implement login/logout endpoints
- Add JWT token generation and validation
- Add authentication middleware

## Related Issues
Closes #123

## Testing
- All unit tests pass
- Manual testing completed on local environment
- Integration tests will run in CI

## Screenshots
N/A (no UI changes)
```

### Step 3: Address Review Comments
```bash
# Make changes based on feedback
# ...

# Commit changes
git add .
git commit -m "fix: address review comments"

# Push to update PR
git push origin feature/user-authentication
```

---

## Common Workflows

### Hotfix Workflow
```bash
# Create hotfix branch from main
git checkout main
git pull origin main
git checkout -b fix/critical-bug

# Fix the bug
# ...

# Test thoroughly
pytest

# Commit
git add .
git commit -m "fix: resolve critical authentication bug

Fixes issue where users couldn't log in after password reset.

Fixes #789"

# Push and create PR
git push -u origin fix/critical-bug
```

### Squashing Commits Before Merge
```bash
# Interactive rebase last 3 commits
git rebase -i HEAD~3

# In editor, change 'pick' to 'squash' for commits to squash
# Save and close editor

# Edit commit message if needed

# Force push
git push --force-with-lease
```
