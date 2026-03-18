# Handoff Document Reference

## HANDOFF.md File Structure

Every HANDOFF.md must include these sections in order:

### 1. Goal
State the end objective in one or two sentences. What does "done" look like?

### 2. Current Status
Summarize overall progress. Use a clear label:
- **Not Started** — No implementation work done yet
- **In Progress** — Actively working, partially complete
- **Blocked** — Cannot proceed without resolving a specific issue
- **Complete** — All work finished, pending review or merge

### 3. What Was Tried
List each approach attempted, with reasoning for why it was chosen.
- Include the order of attempts
- Note which tools, libraries, or strategies were used
- Explain the rationale behind non-obvious decisions

### 4. What Worked
Document completed work and deliverables:
- Specific files created or modified (with paths)
- Tests that pass
- Features that are functional

### 5. What Failed
Document failures with enough detail to avoid repeating them:
- Reference the corresponding "What Was Tried" entry by number (e.g., "Approach #2 failed because…") to avoid duplication
- What was attempted and the exact error or symptom
- Root cause if known, or best hypothesis if not
- Why the approach was abandoned

### 6. Next Steps
Provide concrete, actionable items. Each step should be:
- Specific enough to execute without further research
- Ordered by priority or dependency
- Estimated in scope (e.g., "small change in one file" vs. "requires new module")

### 7. Key Files
List relevant file paths with a brief description of each file's role:
```
src/module/main.py    — Entry point, contains CLI argument parsing
src/module/parser.py  — Config file parser (the file being modified)
tests/test_parser.py  — Tests for the parser module
```

### 8. Notes
Capture anything that doesn't fit elsewhere:
- Environment setup requirements
- Caveats or known limitations
- Non-obvious dependencies
- Credentials or access requirements (reference only, never include secrets)

## Writing Principles

### Be Concise
- Use bullet points over paragraphs
- One idea per bullet
- Cut filler words

### Be Specific
- Include exact file paths, not "the config file"
- Include exact error messages, not "it threw an error"
- Include exact commands, not "run the tests"

### Be Actionable
- Next steps should be executable immediately
- Avoid vague instructions like "investigate further" — instead say what to investigate and where to start
- If a decision is needed, list the options with trade-offs

## When to Write HANDOFF.md

### Session End
Write before the conversation ends or context window fills up. Do not wait until asked — proactively offer when work is incomplete.

### Complex Task Interruption
If a multi-step task is interrupted (e.g., user needs to switch focus), capture the current state immediately.

### Agent Handoff
When explicitly passing work to another agent, the HANDOFF.md is the primary communication channel. It must be self-contained.

## File Location

HANDOFF.md is a file the agent writes in the user's project repository — it is not a skill file installed by this tool.

Place HANDOFF.md in the project root directory by default. If multiple handoffs exist for different workstreams, use descriptive names:
- `HANDOFF.md` — Default, single workstream
- `HANDOFF-auth-migration.md` — Specific workstream
