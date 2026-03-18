name: pr-plan
description: Create structured implementation plan for PR review

# /pr-plan - Create Implementation Plan

Use this skill to create a structured `plan.md` file that serves as the basis for PR review. The plan should be comprehensive enough that reviewers can approve the approach before implementation begins.

## When to Use

- Before starting any non-trivial feature or change
- When the implementation approach needs team alignment
- When creating a PR that will be reviewed based on the plan

## Workflow

### Step 1: Gather Context

1. **Understand the request**: Parse the user's description to identify:
   - What feature/change is being requested
   - Why it's needed (motivation/problem being solved)
   - Any constraints or requirements mentioned

2. **Explore the codebase**: Use the Explore agent to:
   - Find relevant existing code
   - Identify files that will need modification
   - Understand current patterns and architecture

### Step 2: Generate Branch Name

Create a branch name following this pattern:
- Format: `<type>/<ticket-id>-<short-description>`
- Types: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`
- Example: `feat/SOFT-1234-add-kv-cache-optimization`

If no ticket ID is provided, use a descriptive slug:
- Example: `feat/add-streaming-support`

### Step 3: Create plan.md

Write the plan to `plan.md` in the repository root with this structure:

```markdown
# Implementation Plan

## Branch
`<branch-name>`

## Summary
<1-2 sentence description of what this change accomplishes>

## Motivation
<Why is this change needed? What problem does it solve?>

## Proposed Changes

### Overview
<High-level description of the approach>

### Files to Modify
| File | Change Type | Description |
|------|-------------|-------------|
| `path/to/file.py` | Modify | Description of changes |
| `path/to/new_file.py` | Create | Description of new file |

### Implementation Details

#### 1. <First Component/Step>
<Detailed description of what will be done>

```python
# Example code snippet if helpful
```

#### 2. <Second Component/Step>
<Detailed description>

### API Changes (if applicable)
<New functions, classes, or interfaces being introduced>

### Configuration Changes (if applicable)
<New environment variables, settings, or config options>

## Testing Strategy
- [ ] Unit tests for <component>
- [ ] Integration tests for <feature>
- [ ] Manual testing steps

## Risks and Considerations
- <Potential risk or edge case>
- <Migration or backwards compatibility concerns>

## Open Questions (if any)
- [ ] <Question that needs clarification before implementation>

## Acceptance Criteria
- [ ] <Criterion 1>
- [ ] <Criterion 2>
- [ ] <Criterion 3>
```

### Step 4: Present for Review

After creating `plan.md`:
1. Show the user a summary of what was created
2. Ask if they want to:
   - Review and edit the plan
   - Create the branch
   - Proceed to implementation

## Example Usage

**User says:** "I need to add support for dynamic batching based on request priority"

**You should:**
1. Explore the scheduler and batching code
2. Identify relevant files (scheduler, worker, config)
3. Create `plan.md` with:
   - Branch: `feat/add-priority-based-batching`
   - Summary of the feature
   - Files to modify (scheduler_config.py, scheduler.py, etc.)
   - Implementation steps
   - Testing approach

## Rules

- **Be specific**: Include actual file paths and function names
- **Show code examples**: Where the approach isn't obvious
- **List all files**: Even for small changes in many files
- **Include tests**: Every plan must have a testing strategy
- **Flag unknowns**: Use "Open Questions" for things needing clarification
- **NEVER commit `plan.md`**: It is a local working document only — exclude it from all git commits

## After Plan Approval

Once the reviewer approves the plan:
1. Create the branch: `git checkout -b <branch-name>`
2. Use `/implement` to start coding
3. Reference `plan.md` throughout implementation
