# Complexity Gate: /opsx:apply → /opsx:ship Suggestion

When `/opsx:apply` completes all tasks for a change, assess complexity from planning artifacts to determine whether to suggest `/opsx:ship` for team-orchestrated verification.

## When to Evaluate

- After ALL tasks in tasks.md are marked `[x]` (implementation complete)
- Before suggesting `/opsx:archive`

## Complexity Signals

Evaluate these signals from the change's planning artifacts:

| Signal | Source | Complex Threshold |
|--------|--------|-------------------|
| Expected files modified | design.md | 4+ files |
| Spec requirements | specs/**/*.md | 2+ requirements |
| Security/payment domain | specs/, tasks.md | Any auth, payment, webhook, or subscription mention |
| Expected code volume | tasks.md, design.md | 100+ lines estimated |
| New API routes | design.md, tasks.md | Any new `/api/` route |

## Decision Logic

**Complex** (suggest `/opsx:ship`): ANY complex signal is true

**Simple** (proceed normally): NONE of the complex signals match

## Output When Complex

Display complexity assessment:

```
이 변경은 복잡합니다:
- [list all matching signals, e.g., "4+ files modified", "2 spec requirements"]

/opsx:ship으로 팀 검증(OpenSpec verify + Codex review)을 진행할까요?
```

Use **AskUserQuestion** with options:
1. "/opsx:ship 실행 (Recommended)" — team verification + automated fix + archive
2. "/opsx:archive 직접 실행" — skip team verification, archive immediately

## Output When Simple

Proceed with normal apply completion flow:
- Suggest `/opsx:archive` as usual
- No ship suggestion needed
