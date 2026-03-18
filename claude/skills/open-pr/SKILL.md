---
name: open-pr
description: Automatically fill PR template from plan.md, commit, push, and open a GitHub pull request for the current branch. Use when the user says "open pr", "create pr", "submit pr", or any variation of opening a pull request.
---

# /open-pr - Open Pull Request

Use this skill after implementation is complete to create a GitHub pull request. It reads the existing `plan.md`, fills in the PR template, runs pre-commit checks, commits any remaining changes, pushes, and opens the PR.

## Prerequisites

- `gh` CLI installed and authenticated (`gh auth login`)
- Inside a git repository on a feature branch (not `main`/`master`)
- `plan.md` exists in the repository root
- Implementation work is complete (code changes are committed or staged)

## Workflow

### Step 1: Validate Environment

1. **Check current branch**: Must NOT be `main` or `master`.
2. **Check `plan.md` exists**: Read `plan.md` from the repository root. If it doesn't exist, inform the user and stop.
3. **Check for existing PR**: Run `gh pr list --head <branch> --json number --jq '.[0].number'`. If a PR already exists, inform the user and ask if they want to update it or stop.
4. **Detect base branch**: Default to `main`. Verify it exists with `git rev-parse --verify main`.

### Step 2: Read plan.md and Extract Information

Parse `plan.md` to extract:
1. **Branch name** from the `## Branch` section
2. **Summary** from the `## Summary` section (used for PR title and summary)
3. **PR type** inferred from the branch name prefix:
   - `feat/` → feat
   - `fix/` → fix
   - `docs/` → docs
   - `refactor/` → refactor
   - `test/` → test
   - `chore/` → chore
   - `perf/` → perf
   - `style/` → style
   - If no recognized prefix, ask the user which PR type applies
4. **Full plan content** (the entire `plan.md` will be embedded in the PR body)

### Step 3: Run Tests and Capture Results

Run the test suite to capture results for the PR body:

```bash
source .venv/bin/activate
pytest tests/python/unit_test -v 2>&1 | tail -20
```

Capture:
- Which tests were run (e.g., `pytest tests/python/unit_test/worker/`)
- Result summary (e.g., "12 passed in 3.2s")

If tests fail, inform the user and ask whether to proceed anyway or stop to fix.

### Step 4: Format, Lint, and Pre-commit

**IMPORTANT**: Always activate the venv and run the full pipeline before committing.

```bash
source .venv/bin/activate
pre-commit install
ruff format .
ruff check --fix .
pre-commit run --all-files
```

If pre-commit modifies any files, re-run `pre-commit run --all-files` until all hooks pass cleanly.

### Step 5: Commit Remaining Changes

If there are any uncommitted changes after formatting/linting:

```bash
# Stage all changes (but NEVER stage plan.md)
git add -A
git reset HEAD plan.md 2>/dev/null || true

# Check if there are staged changes
git diff --cached --quiet || git commit -m "chore: final formatting and cleanup before PR"
```

If there are no changes to commit, skip this step.

### Step 6: Build PR Body

Construct the PR body by filling in the `PR_TEMPLATE.md` template. Use the template from `.claude/skills/open-pr/PR_TEMPLATE.md` as the structure and fill in each section:

#### Section 1: PR Type
Check the appropriate box based on the branch name prefix detected in Step 2:

```markdown
* [x] feat: 새로운 기능 추가
```

(Only one type should be checked. If multiple apply, check all that apply.)

#### Section 2: Summary of Changes
Fill in the summary extracted from `plan.md`'s `## Summary` section:

```markdown
* 핵심 요약: <summary from plan.md>
```

#### Section 3: Full Implementation Plan
Embed the **entire contents** of `plan.md` in this section inside a collapsible `<details>` block:

```markdown
<details>
<summary>Click to expand full implementation plan</summary>

<content of plan.md>

</details>
```

#### Section 4: Test & Human Review
Fill in with the test results captured in Step 3:

```markdown
### 테스트 수행 결과

* 실행한 테스트: `pytest tests/python/unit_test/ -v`
* 결과 요약: <test result summary, e.g., "15 passed in 4.1s">
```

Leave the reviewer checklist unchecked (those are for human reviewers).

#### Section 5: Final Checklist
Check all items that were verified:

```markdown
* [x] 제 코드가 프로젝트의 코드 스타일 가이드라인을 따릅니다.
* [x] 제 코드가 새로운 경고를 발생시키지 않습니다.
* [ ] 변경 사항에 대한 테스트를 작성했습니다.
* [x] 기존 테스트가 모두 통과합니다.
* [ ] 필요한 경우 문서(documentation)를 업데이트했습니다.
```

- Check the style/warnings items only if they were verified in Steps 3-4.
- Leave the "tests written" item unchecked — the skill runs existing tests but cannot verify new tests were added. The developer should manually confirm this.
- Leave the documentation item unchecked unless docs were explicitly updated.

### Step 7: Generate PR Title

Create a concise PR title (under 70 characters) from `plan.md`:

Format: `[<TICKET-ID>] <Summary>`

Examples:
- `[SOFT-1234] Add priority-based dynamic batching`
- `[SOFT-2820] Add pr-review skill for fetching PR review feedback`

If no ticket ID is found in the branch name, omit the bracket prefix:
- `Add streaming support for inference requests`

### Step 8: Confirm with User Before Creating PR

**IMPORTANT**: Do NOT create the PR automatically. Always show the user:

1. **PR Title** (generated in Step 7)
2. **Target branch** (e.g., `main`)
3. **PR body preview** (abbreviated — show the summary and PR type, note that plan.md is included)
4. **Test results** (pass/fail summary)
5. **Commits included** (output of `git log main..HEAD --oneline`)

Ask: "Ready to push and create this PR? (yes/no)"

If user wants to modify the title or body, make adjustments before proceeding.

### Step 9: Push and Create PR

Only after explicit user confirmation:

```bash
# Push to remote (always use the explicit branch name)
git push -u origin <branch-name>

# Create PR using gh CLI
gh pr create --title "<PR title>" --body "$(cat <<'EOF'
<filled PR body>
EOF
)"
```

After creation, display:
- The PR URL
- PR number
- A brief success message

## Error Handling

| Error | Action |
|-------|--------|
| Not on a feature branch | Inform user, stop |
| No `plan.md` found | Inform user to run `/plan` first, stop |
| PR already exists | Show existing PR URL, ask if they want to update or stop |
| Tests fail | Show failures, ask if they want to proceed or fix first |
| Pre-commit fails | Fix and retry (up to 3 times), then ask user |
| `gh` CLI not authenticated | Inform user to run `gh auth login`, stop |
| Push fails | Show error, suggest `git pull --rebase` if behind remote |

## Example Usage

User says: "open a pr"

1. Read `plan.md` — extract summary: "Add pr-review skill for fetching PR review feedback"
2. Detect branch: `SOFT-2820-code-review-claude-code-vllm-hyperaccel-workflow`
3. Infer ticket ID: `SOFT-2820`
4. Run tests → 12 passed
5. Run formatters → no changes
6. Build PR body with filled template
7. Show user: Title = `[SOFT-2820] Add pr-review skill for fetching PR review feedback`
8. User confirms → push and create PR
9. Display: `https://github.com/hyperaccel/vllm-hyperaccel/pull/84`

## Notes

- Always uses the current branch — never ask the user which branch
- The PR body is in Korean following the team's template convention
- `plan.md` is never committed (it's in `.gitignore`) but its content is embedded in the PR body
- If the branch has no commits beyond `main`, inform the user there's nothing to create a PR for
- The skill reads `.claude/skills/open-pr/PR_TEMPLATE.md` as the template structure — if the template is updated, the skill automatically follows the new format
