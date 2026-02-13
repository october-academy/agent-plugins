# TASK

Read the verification report at `openspec/changes/<CHANGE_NAME>/verify-report.md` (or `combined-report.md` if it exists) and fix ALL listed issues — CRITICAL, WARNING, and SUGGESTION.

# EXPECTED OUTCOME

- All CRITICAL issues are resolved in the codebase
- All WARNING issues are resolved
- All SUGGESTION issues are addressed where feasible
- Fix summary written to `openspec/changes/<CHANGE_NAME>/fix-summary.md`
- Any tasks in tasks.md that are implemented but unchecked are marked `[x]`

# CONTEXT

- **Change directory**: `openspec/changes/<CHANGE_NAME>/`
- **Planning artifacts** (read these for intent and requirements):
  - `proposal.md` — what and why
  - `design.md` — technical approach and decisions
  - `specs/` — delta specs (requirements and scenarios)
  - `tasks.md` — implementation checklist
- **Verification report**: `verify-report.md` or `combined-report.md` — contains issues with `file:line` references
- **Project patterns**: see `CLAUDE.md` for coding conventions, styling, and architecture

# CONSTRAINTS

- Keep changes **minimal and scoped** to each issue
- Do NOT refactor or improve code beyond what's needed to fix the issue
- Do NOT modify change artifacts (proposal.md, design.md, specs/)
- If a design decision in design.md conflicts with current code, update the **code** to match design
- If tasks.md has items that are already implemented but unchecked, **check them off**
- Follow project patterns from CLAUDE.md (Neo-Brutalism styling, Supabase patterns, etc.)

# MUST DO

- Read the verification/combined report first
- Read referenced source files for each issue before fixing
- Fix each issue at the specific `file:line` referenced
- Write `fix-summary.md` documenting all fixes applied
- Document any issues that could not be fixed in "Could Not Fix" section

# MUST NOT DO

- Modify proposal.md, design.md, or specs/ files
- Add features or capabilities not defined in the specs
- Change test expectations to match bugs (fix the code, not the test)
- Delete or disable existing tests
- Introduce new dependencies without justification
- Make stylistic changes unrelated to the reported issues

# OUTPUT FORMAT

Write fix summary to `openspec/changes/<CHANGE_NAME>/fix-summary.md`:

```
# Fix Summary: <CHANGE_NAME>

## Fixes Applied

### CRITICAL
- [original issue] → Fixed in `file.ts:line` — [what was changed]

### WARNING
- [original issue] → Fixed in `file.ts:line` — [what was changed]

### SUGGESTION
- [original issue] → Fixed in `file.ts:line` — [what was changed]

## Could Not Fix
- [issue] — Reason: [explanation]
```
