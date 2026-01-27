# Wrap

Session wrap-up workflow with multi-agent analysis for documentation, automation, learning points, and follow-up suggestions.

## Installation

```bash
# 1. Add marketplace (first time only)
claude plugin marketplace add october-academy/claude-plugins

# 2. Update marketplace
claude plugin marketplace update

# 3. Install plugin
claude plugin install wrap@october-plugins

# 4. Restart Claude Code
```

## Usage

```bash
/wrap:session                    # Interactive session wrap-up
/wrap:session fix typo in README # Quick commit with provided message
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

| Agent | Model | Role |
|-------|-------|------|
| `doc-updater` | sonnet | Analyze documentation update needs |
| `automation-scout` | sonnet | Detect automation opportunities |
| `learning-extractor` | sonnet | Extract learning points and mistakes |
| `followup-suggester` | sonnet | Suggest follow-up tasks |
| `duplicate-checker` | haiku | Validate proposal duplicates |

## Workflow

1. Check git status
2. Phase 1: Run 4 analysis agents in parallel
3. Phase 2: Validate proposal duplicates
4. Present results and action options
5. Execute selected actions

## When to Use

**Use:**
- At the end of a work session
- Before switching to another project
- After completing a feature or bug fix

**Skip:**
- Short sessions with trivial changes
- Code reading/exploration only
- Quick one-off questions

## License

MIT
