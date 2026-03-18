# Handoff Document Examples

## Bad: Vague Handoff

```markdown
# HANDOFF.md

## Goal
Fix the authentication system.

## Current Status
In progress.

## What Was Tried
- Tried changing the config
- Looked at the database

## What Worked
- Some tests pass now

## What Failed
- Something broke when I changed the auth logic

## Next Steps
- Keep debugging
- Fix the remaining issues

## Key Files
- The auth module
- The test files

## Notes
- Need to set up the environment first
```

**Why this is bad:**
- No file paths — "the auth module" could be anything
- No error messages — "something broke" is not actionable
- Vague next steps — "keep debugging" gives zero direction
- No specifics on what tests pass or what "some" means

---

## Minimal: Quick Context Switch

Use this format when a task is small or the interruption is brief — not every handoff needs all 8 sections.

```markdown
# HANDOFF.md

## Goal
Add pagination to `GET /api/v1/posts` endpoint.

## Current Status
**In Progress** — Backend query supports `limit`/`offset`, but response envelope not yet updated.

## What Worked
- Added `limit` and `offset` query params in `src/api/v1/posts.py:L42-L55`
- Database query uses `.limit().offset()` — tested manually, works

## Next Steps
1. Update response format in `src/api/v1/posts.py:L60` to include `total_count`, `page`, `per_page`
2. Add tests in `tests/test_posts.py` for pagination edge cases (empty page, last page)

## Key Files
src/api/v1/posts.py   — Endpoint being modified
tests/test_posts.py   — Test file (needs new tests)
```

---

## Good: Specific Handoff

```markdown
# HANDOFF.md

## Goal
Migrate user authentication from session-based to JWT tokens. All existing API endpoints must accept JWT in the Authorization header. Session-based auth should remain functional during the transition period.

## Current Status
**In Progress** — Token generation and validation are complete. 3 of 12 API endpoints have been migrated.

## What Was Tried
1. Initially attempted to use PyJWT library directly, but switched to python-jose for built-in JWK support
2. Tried storing refresh tokens in Redis, but opted for database storage to simplify deployment

## What Worked
- JWT token generation and validation: `src/auth/jwt_handler.py`
- Token refresh endpoint: `POST /api/v1/auth/refresh`
- Migrated endpoints: `/api/v1/users/me`, `/api/v1/users/settings`, `/api/v1/users/logout`
- All 14 existing auth tests pass, plus 8 new JWT-specific tests

## What Failed
- Rate limiting middleware conflicts with JWT validation order — requests are rate-limited before token validation, causing valid requests to return 429 instead of 401 for expired tokens. Needs middleware reordering in `src/middleware/pipeline.py`.

## Next Steps
1. Migrate remaining 9 API endpoints in `src/api/v1/` (each endpoint is a ~5-line change in the decorator)
2. Fix middleware ordering in `src/middleware/pipeline.py:L45-L52` — move `JWTMiddleware` before `RateLimitMiddleware`
3. Add integration tests for the token refresh flow in `tests/integration/test_auth_flow.py`
4. Update API documentation in `docs/api.md` to include JWT header format

## Key Files
src/auth/jwt_handler.py       — Token generation, validation, and refresh logic
src/auth/models.py             — TokenPair and RefreshToken database models
src/middleware/pipeline.py     — Middleware ordering (needs fix at L45-L52)
src/api/v1/users.py            — Example of migrated endpoint
tests/unit/test_jwt_handler.py — Unit tests for JWT operations
tests/integration/              — Integration test directory (needs new test file)

## Notes
- JWT secret is loaded from `JWT_SECRET` environment variable — must be set before running
- Token expiry is set to 15 minutes (access) and 7 days (refresh) in `src/auth/config.py`
- The migration is backwards-compatible: endpoints accept both session cookies and JWT headers
```

---

## Better: Detailed Handoff with Diagnostics

```markdown
# HANDOFF.md

## Goal
Fix flaky test `test_concurrent_upload` in the file upload service. The test passes locally but fails ~30% of the time in CI. The CI pipeline has been red for 3 days and is blocking the v2.1 release.

## Current Status
**In Progress** — Root cause identified as a race condition. Fix is implemented but not yet validated in CI.

## What Was Tried
1. **Added retry logic to the test** (reverted) — Masked the issue without fixing it. Test still failed intermittently even with 3 retries.
2. **Increased timeout from 5s to 30s** (reverted) — No effect, confirming the issue is not a simple timeout.
3. **Added debug logging to `src/upload/worker.py`** (kept) — Revealed that two workers occasionally process the same chunk, causing a duplicate key error in the database.

## What Worked
- Root cause identified: `src/upload/worker.py:L89` acquires a file-level lock, but chunk processing at L112 does not check if the chunk is already claimed. Two workers can claim the same chunk between L89 and L112.
- Fix implemented: Added a database-level advisory lock per chunk in `src/upload/worker.py:L110-L115`:
  ```python
  # Added advisory lock to prevent duplicate chunk processing
  with db.advisory_lock(f"chunk_{file_id}_{chunk_index}"):
      if not Chunk.objects.filter(file_id=file_id, index=chunk_index, status="processing").exists():
          chunk.status = "processing"
          chunk.save()
  ```
- Local stress test (`pytest tests/test_upload.py -x --count=50`) passed 50/50 times with the fix.

## What Failed
- The `threading.Lock` approach (tried before advisory lock) did not work because CI runs workers as separate processes, not threads. A process-level lock was needed.
- Attempted to use `filelock` library but it does not work on the CI environment's ephemeral filesystem (no persistent `/tmp`).

## Next Steps
1. Push the current branch `fix/flaky-upload-test` and verify CI passes — the fix is already committed
2. If CI still fails, check if CI runs multiple containers (not just multiple processes). If so, the advisory lock may need to be replaced with a Redis-based distributed lock using `src/common/redis_lock.py`
3. Remove debug logging added in `src/upload/worker.py:L95-L100` after CI is confirmed green
4. Open PR to merge `fix/flaky-upload-test` into `main`

## Key Files
src/upload/worker.py           — Upload worker with the race condition fix (L110-L115)
tests/test_upload.py           — The flaky test (test_concurrent_upload at L203)
src/common/redis_lock.py       — Distributed lock utility (fallback if advisory lock is insufficient)
.github/workflows/ci.yml       — CI config, runs 4 parallel workers (relevant to reproduction)

## Notes
- To reproduce locally: `pytest tests/test_upload.py::test_concurrent_upload -x --count=50 --forked`
- The `--forked` flag is critical — it simulates CI's process-based parallelism
- CI environment uses PostgreSQL 15, which supports advisory locks natively
- The `fix/flaky-upload-test` branch is 2 commits ahead of `main`
```
