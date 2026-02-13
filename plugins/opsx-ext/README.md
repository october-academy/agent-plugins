# opsx-ext

OpenSpec 확장 플러그인 — team-orchestrated **ship** 워크플로우를 제공합니다.

변경사항을 구현(implement) → 검증(verify) → 수정(fix) → 아카이브(archive) 사이클로 자동 처리하며, Claude Code(leader) + Codex(reviewer)를 조합한 dual verification을 수행합니다.

## Installation

### Skills (Claude Code + Codex)

```bash
npx skills add october-academy/agent-plugins -a claude-code -a codex --skill opsx-ext -y
```

### Claude Code Plugin

```bash
# 1. Add marketplace (first time only)
claude plugin marketplace add october-academy/agent-plugins

# 2. Update marketplace
claude plugin marketplace update

# 3. Install plugin
claude plugin install opsx-ext@agent-plugins

# 4. Restart Claude Code
```

### Manual

Copy `commands/ship.md` to `.claude/commands/opsx/ship.md` in your project.

### Extras (rules + codex prompts)

Extras are not part of the standard plugin components and require a separate install step:

```bash
# Install extras into your project
./install-extras.sh --project-root /path/to/your/project

# Overwrite without backup
./install-extras.sh --project-root /path/to/your/project --force

# Remove extras
./install-extras.sh --project-root /path/to/your/project --uninstall
```

This installs:
- `.claude/rules/opsx-ship-gate.md` — Complexity gate (auto-suggests `/opsx:ship` after `/opsx:apply`)
- `.codex/prompts/verify-fix-loop.md` — Codex fix prompt template
- `.codex/prompts/code-review.md` — Codex code review prompt template

## Usage

```
/opsx:ship [change-name]
```

If no change name is provided, you'll be prompted to select one.

## Workflow Phases

| Phase | What happens |
|-------|-------------|
| 1. Implement | Implementer agent applies all tasks from `tasks.md` |
| 2. Dual Verify | Leader runs OpenSpec verify + Reviewer runs Codex code review in parallel |
| 3. Fix Loop | Codex fixes reported issues (max 3 rounds), leader re-verifies |
| 4. Archive | Change moved to archive directory, specs synced |
| 5. Cleanup | Team shutdown and resource cleanup |

## Components

| Component | Path | Description |
|-----------|------|-------------|
| Command | `commands/ship.md` | Claude Code `/opsx:ship` command |
| Skill | `skills/opsx-ext-ship/SKILL.md` | Agent Skills format (for `npx skills add`) |
| Rule | `extras/rules/opsx-ship-gate.md` | Complexity gate — auto-suggests ship after apply |
| Codex prompt | `extras/codex-prompts/verify-fix-loop.md` | Fix prompt template for Codex exec |
| Codex prompt | `extras/codex-prompts/code-review.md` | Code review prompt template for Codex exec |
| Installer | `install-extras.sh` | Copies extras to project directories |

## Prerequisites

- [OpenSpec CLI](https://github.com/october-academy/openspec) installed
- [Codex CLI](https://github.com/openai/codex) installed (for review + fix phases)
- A project with OpenSpec changes (`openspec/changes/`)

## OpenSpec Coexistence

This plugin extends OpenSpec without modifying upstream files. The `/opsx:ship` command orchestrates existing OpenSpec commands (`openspec list`, `openspec status`, `/opsx:archive`, `/opsx:verify`) and adds team-based verification on top.

`openspec update` will not conflict with this plugin since ship is an extension, not an override.

## Uninstall

```bash
# Remove plugin
claude plugin uninstall opsx-ext@agent-plugins

# Remove extras
./install-extras.sh --project-root /path/to/your/project --uninstall
```
