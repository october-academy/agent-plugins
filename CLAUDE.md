# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Claude Code plugin marketplace. Each plugin lives in `plugins/<plugin-name>/`.

## Commands

```bash
# Validate all plugins
./scripts/validate-plugins.sh

# Check JSON syntax
cat plugins/<name>/.claude-plugin/plugin.json | jq .

# Verify version consistency
grep -r '"version"' plugins/*/.claude-plugin/plugin.json .claude-plugin/marketplace.json
```

## Plugin Structure

```
plugins/<plugin-name>/
├── .claude-plugin/
│   └── plugin.json          # Required: metadata
├── README.md                 # Required: documentation
├── commands/<cmd>.md         # Slash commands (/plugin:cmd)
├── skills/<skill>/SKILL.md   # Skills (auto or /skill)
├── agents/<agent>.md         # Agents (Task tool subagent_type)
├── hooks/hooks.json          # Event hooks (Stop, PreToolUse, PostToolUse)
└── .mcp.json                 # MCP server config
```

## Creating a Plugin

1. Create `plugins/<name>/.claude-plugin/plugin.json`
2. Create `plugins/<name>/README.md` with Installation section
3. Add commands/, skills/, agents/, or hooks/ as needed
4. Register in `.claude-plugin/marketplace.json`
5. Run `./scripts/validate-plugins.sh` to verify

See [PLUGIN_DEVELOPMENT.md](./PLUGIN_DEVELOPMENT.md) for detailed templates and best practices.

## File Formats

### plugin.json (Required)

```json
{
  "name": "plugin-name",
  "version": "1.1.0",
  "description": "Plugin description",
  "author": { "name": "Author Name" }
}
```

### commands/<cmd>.md

```markdown
---
description: Command description
argument-hint: [optional arguments]
allowed-tools: Bash(git:*), Read, Edit
---

# Instructions...
```

### skills/<skill>/SKILL.md

```markdown
---
name: skill-name
description: Skill description
user-invocable: true
---

# Instructions...
```

### agents/<agent>.md

```markdown
---
name: agent-name
description: Agent description
model: haiku  # haiku | sonnet | opus
---

# Instructions...
```

### hooks/hooks.json

```json
{
  "hooks": {
    "Stop": [{ "hooks": [{ "type": "command", "command": "${CLAUDE_PLUGIN_ROOT}/hooks/stop-hook.sh" }] }]
  }
}
```

## Existing Plugins

| Plugin | Type | Trigger |
|--------|------|---------|
| clarify | skills, hooks | `/clarify` |
| feature-dev | skills, agents, hooks | `/feature-dev` |
| frontend-design | skills | `/frontend-design` (auto) |
| git | commands | `/git:push`, `/git:push-pr` |
| interview-prompt-builder | skills | `/interview-prompt-builder` (auto) |
| linear | mcp | - |
| simplify | skills, agents, hooks | `/simplify` |
| typescript-lsp | mcp | - |
| web-perf-ux | skills | `/web-perf-ux` (auto) |
| wrap | skills, agents, hooks | `/wrap` |

## Key Conventions

- **Naming**: Short, action-oriented (`wrap` not `session-wrap`)
- **Versioning**: Keep plugin.json and marketplace.json versions in sync
- **README**: Always include standardized Installation section
- **Hooks**: Make scripts executable (`chmod +x`)
- **Agent models**: haiku (validation), sonnet (analysis), opus (architecture)
