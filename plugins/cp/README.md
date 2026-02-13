# CP (Commit & Push)

Stage, commit, and push changes in a single command.

## Installation

```bash
# 1. Add marketplace (first time only)
claude plugin marketplace add october-academy/agent-plugins

# 2. Update marketplace
claude plugin marketplace update

# 3. Install plugin
claude plugin install cp@october-plugins

# 4. Restart Claude Code
```

## Usage

```bash
/cp                        # Auto-generate commit message
/cp "fix: resolve bug"     # Use provided message
```

### Korean Triggers

- "커밋하고 푸시"
- "커밋 푸시"
- "변경사항 올려줘"

## How It Works

```
┌───────────────────────────────────────────┐
│  /cp                                       │
└──────────────────┬────────────────────────┘
                   │
                   ▼
┌───────────────────────────────────────────┐
│  1. Analyze changes (git status, diff)     │
└──────────────────┬────────────────────────┘
                   │
                   ▼
┌───────────────────────────────────────────┐
│  2. Generate commit message                │
│     (Conventional Commits format)          │
└──────────────────┬────────────────────────┘
                   │
                   ▼
┌───────────────────────────────────────────┐
│  3. Stage files (specific, not -A)         │
│     - Checks for .env, secrets             │
└──────────────────┬────────────────────────┘
                   │
                   ▼
┌───────────────────────────────────────────┐
│  4. Commit with Co-Authored-By             │
└──────────────────┬────────────────────────┘
                   │
                   ▼
┌───────────────────────────────────────────┐
│  5. Push to origin                         │
└───────────────────────────────────────────┘
```

## Commit Message Format

| Prefix | Use Case |
|--------|----------|
| `feat:` | New feature |
| `fix:` | Bug fix |
| `docs:` | Documentation |
| `refactor:` | Code restructuring |
| `style:` | Formatting (no logic change) |
| `test:` | Adding tests |
| `chore:` | Maintenance tasks |

## Safety Checks

- Scans for API keys, passwords, tokens
- Verifies correct branch
- Reviews diff before committing

## License

MIT
