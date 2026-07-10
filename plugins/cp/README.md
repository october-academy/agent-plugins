# CP (Commit & Push)

Stage, commit, and push changes in a single command. Does not create,
review, or merge pull requests — for those, use a different skill.

## Installation

```bash
# 1. Add marketplace (first time only)
claude plugin marketplace add october-academy/agent-plugins

# 2. Update marketplace
claude plugin marketplace update

# 3. Install plugin
claude plugin install cp@agent-plugins

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

`<current-branch>` below always means the output of `git branch --show-current`.

```
┌───────────────────────────────────────────┐
│  /cp                                       │
└──────────────────┬────────────────────────┘
                   │
                   ▼
┌───────────────────────────────────────────┐
│  1. Protected branch check                 │
│     - Stop + confirm if main/master        │
└──────────────────┬────────────────────────┘
                   │
                   ▼
┌───────────────────────────────────────────┐
│  2. Analyze changes (git status, diff,     │
│     git log -5 for trailer convention)     │
└──────────────────┬────────────────────────┘
                   │
                   ▼
┌───────────────────────────────────────────┐
│  3. Stage files (specific, not -A)         │
│     - Checks for .env, secrets             │
│     - Secret scan on the staged diff       │
└──────────────────┬────────────────────────┘
                   │
                   ▼
┌───────────────────────────────────────────┐
│  4. Generate commit message from the       │
│     staged diff (Conventional Commits)     │
└──────────────────┬────────────────────────┘
                   │
                   ▼
┌───────────────────────────────────────────┐
│  5. Commit (trailer only if the repo       │
│     already uses that convention)          │
└──────────────────┬────────────────────────┘
                   │
                   ▼
┌───────────────────────────────────────────┐
│  6. Push to origin <current-branch>        │
│     - Rejected → fetch, never bare pull    │
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

- Stops and asks for confirmation before committing or pushing to `main`/`master`
- Scans the staged diff for API keys, passwords, tokens, private keys
- Reviews the staged diff before generating the commit message
- On a rejected push, never runs a bare `git pull` — fetches first, fast-forwards
  only when safe, and reports diverged history to you instead of auto-merging
  or auto-rebasing

## License

MIT
