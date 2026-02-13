# Code Review Task

Review the code changes for OpenSpec change `<CHANGE_NAME>`.

## Scope

Identify files modified for this change by reading the planning artifacts at `openspec/changes/<CHANGE_NAME>/`:
- `tasks.md` — completed tasks reference affected files
- `design.md` — lists expected file modifications
- `proposal.md` — describes the change scope

Review all modified and newly created files against the change requirements.

## Review Dimensions

### 1. Security (OWASP Top 10)
- Input validation and sanitization at system boundaries
- Authentication and authorization checks (Supabase Auth patterns)
- SQL injection, XSS, command injection risks
- Sensitive data exposure (env vars, API keys, tokens)
- CSRF protection on state-changing endpoints
- Rate limiting on public endpoints

### 2. Performance
- N+1 queries or unnecessary database calls
- Missing indexes for new query patterns
- Unbounded loops or large array operations
- Memory leaks or missing resource cleanup
- Unnecessary re-renders in React components
- Bundle size impact (dynamic imports where appropriate)

### 3. Correctness
- Logic errors and unhandled edge cases
- Error handling completeness
- Type safety issues (TypeScript strict mode)
- Race conditions in async operations
- Off-by-one errors
- Null/undefined handling

### 4. Maintainability
- Consistent naming conventions with existing codebase
- Appropriate abstraction level (not over-engineered)
- Pattern consistency with CLAUDE.md conventions
- Dead code or unused imports
- Clear control flow

## Output Format

Write review report to `openspec/changes/<CHANGE_NAME>/review-report.md`:

```
# Code Review: <CHANGE_NAME>

## Summary
| Dimension       | Finding Count | Max Severity |
|-----------------|---------------|--------------|
| Security        | N             | ...          |
| Performance     | N             | ...          |
| Correctness     | N             | ...          |
| Maintainability | N             | ...          |

## CRITICAL
- [finding] — `file.ts:line` — Recommendation: ...

## WARNING
- [finding] — `file.ts:line` — Recommendation: ...

## SUGGESTION
- [finding] — `file.ts:line` — Recommendation: ...

## Assessment
[Overall code quality summary and readiness assessment]
```
