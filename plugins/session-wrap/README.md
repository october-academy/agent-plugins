# Session-Wrap Plugin

Session wrap-up workflow with multi-agent analysis for documentation, automation, learning, and follow-up suggestions.

## Installation

```bash
claude plugin install session-wrap@october-plugins
```

## Usage

```bash
/wrap                    # Interactive session wrap-up
/wrap fix typo in README # Quick commit with message
```

## Architecture

```
Phase 1: Analysis (Parallel)
┌──────────────┬──────────────┬──────────────┬──────────────┐
│ doc-updater  │ automation-  │ learning-    │ followup-    │
│              │ scout        │ extractor    │ suggester    │
└──────┬───────┴──────┬───────┴──────┬───────┴──────┬───────┘
       └──────────────┴──────────────┴──────────────┘
                            │
                            ▼
Phase 2: Validation (Sequential)
┌─────────────────────────────────────────────────────────────┐
│                    duplicate-checker                         │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
                    User Selection
```

## Agents

| Agent | Model | Purpose |
|-------|-------|---------|
| `doc-updater` | sonnet | Analyze documentation update needs |
| `automation-scout` | sonnet | Detect automation opportunities |
| `learning-extractor` | sonnet | Extract learnings and mistakes |
| `followup-suggester` | sonnet | Suggest prioritized follow-up tasks |
| `duplicate-checker` | haiku | Validate proposals for duplicates |

## Workflow

1. **Check git status**
2. **Phase 1**: Run 4 analysis agents in parallel
3. **Phase 2**: Validate proposals for duplicates
4. **Present results** and let you choose actions
5. **Execute** selected actions

## When to Use

**Use `/wrap` when:**
- Ending a significant work session
- Before switching to a different project
- After completing a feature or bug fix

**Skip when:**
- Very short session with trivial changes
- Only reading/exploring code
- Quick one-off question answered

## License

MIT
