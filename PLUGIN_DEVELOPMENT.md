# Plugin Development Guide

A comprehensive guide for creating plugins for Claude Code.

## Table of Contents

- [Overview](#overview)
- [Plugin Types](#plugin-types)
- [Directory Structure](#directory-structure)
- [Creating a Plugin](#creating-a-plugin)
- [Templates](#templates)
- [Best Practices](#best-practices)
- [Common Mistakes](#common-mistakes)

## Overview

Claude Code plugins extend functionality through commands, skills, agents, hooks, and MCP servers. Each plugin lives in its own directory under `plugins/`.

## Plugin Types

### Commands

User-invoked slash commands (e.g., `/git:push`).

- **When to use**: Direct user actions, one-shot operations
- **Trigger**: User types `/plugin:command`
- **Location**: `commands/<command>.md`

### Skills

Automatic or user-invocable capabilities.

- **When to use**: Context-aware assistance, complex multi-step workflows
- **Trigger**: Automatic detection or `/skill` invocation
- **Location**: `skills/<skill>/SKILL.md`

### Agents

Specialized subagents for Task tool delegation.

- **When to use**: Background processing, parallel analysis, specialized tasks
- **Trigger**: Called via Task tool with `subagent_type`
- **Location**: `agents/<agent>.md`

### Hooks

Event-driven scripts that run on specific triggers.

- **When to use**: Automatic suggestions, validation, notifications
- **Trigger**: Stop, PreToolUse, PostToolUse events
- **Location**: `hooks/hooks.json` + scripts

### MCP Servers

External tool integrations via Model Context Protocol.

- **When to use**: Third-party API integrations, external services
- **Trigger**: Tool calls to MCP-provided tools
- **Location**: `.mcp.json`

## Decision Framework

```
Need direct user action?
  └─ Yes → Command
  └─ No  → Need automatic detection?
              └─ Yes → Skill (auto-trigger)
              └─ No  → Need background/parallel work?
                          └─ Yes → Agent
                          └─ No  → Need event-driven behavior?
                                      └─ Yes → Hook
                                      └─ No  → Need external API?
                                                  └─ Yes → MCP Server
```

## Directory Structure

```
plugins/<plugin-name>/
├── .claude-plugin/
│   └── plugin.json          # Required: metadata
├── README.md                 # Required: documentation
├── commands/                 # Slash commands
│   └── <command>.md
├── skills/                   # Skills
│   └── <skill>/
│       └── SKILL.md
├── agents/                   # Agents
│   └── <agent>.md
├── hooks/                    # Hooks
│   ├── hooks.json
│   └── <hook-script>.sh
└── .mcp.json                 # MCP server config
```

## Creating a Plugin

### Step 1: Create Directory

```bash
mkdir -p plugins/<name>/.claude-plugin
```

### Step 2: Create plugin.json

```json
{
  "name": "plugin-name",
  "version": "1.0.0",
  "description": "Brief description of what the plugin does",
  "author": {
    "name": "Your Name",
    "email": "your@email.com"
  }
}
```

### Step 3: Create README.md

Include:
- Installation instructions
- Usage examples
- Features list
- Configuration (if any)

### Step 4: Add to Marketplace

Edit `.claude-plugin/marketplace.json`:

```json
{
  "name": "plugin-name",
  "description": "Plugin description",
  "version": "1.0.0",
  "author": { "name": "Your Name" },
  "source": "./plugins/plugin-name",
  "category": "productivity"
}
```

Categories: `productivity`, `development`, `integration`

### Step 5: Create Components

Add commands, skills, agents, or hooks as needed.

## Templates

### Command Template

```markdown
---
description: Brief command description
argument-hint: [optional arguments]
allowed-tools: Bash(git:*), Read, Edit
---

# Command Name

Description of what the command does.

## Usage

\`\`\`
/plugin:command [args]
\`\`\`

## Workflow

1. Step one
2. Step two
3. Step three

## Notes

- Important considerations
```

### Skill Template

```markdown
---
name: skill-name
description: Brief skill description
user-invocable: true
argument-hint: [optional arguments]
---

# Skill Name

Description of what the skill does.

## When to Trigger

- Condition 1
- Condition 2

## Execution Flow

1. Step one
2. Step two
3. Step three

## Output

What the skill produces.
```

### Agent Template

```markdown
---
name: agent-name
description: Brief agent description
model: haiku
---

# Agent Name

Description of what the agent does.

## Input

What the agent expects as input.

## Process

1. Step one
2. Step two

## Output

What the agent returns.
```

### Hook Template (hooks.json)

```json
{
  "description": "Hook description",
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/hooks/stop-hook.sh"
          }
        ]
      }
    ]
  }
}
```

Hook types: `Stop`, `PreToolUse`, `PostToolUse`

## Best Practices

### Naming

- **Plugins**: Short, action-oriented verbs (`wrap`, `simplify`, `git`)
- **Commands**: Verb-based (`push`, `commit`, `analyze`)
- **Skills**: Noun or verb-noun (`frontend-design`, `web-perf-ux`)
- **Agents**: Role-based (`doc-updater`, `learning-extractor`)

### Documentation

- Always include installation instructions in README
- Provide usage examples
- Document expected inputs and outputs
- Keep descriptions concise but complete

### Versioning

- Use semantic versioning (major.minor.patch)
- Bump minor version for new features
- Bump patch version for bug fixes
- Keep plugin.json and marketplace.json versions in sync

### Agent Model Selection

| Model | Use Case |
|-------|----------|
| `haiku` | Quick validation, simple checks, deduplication |
| `sonnet` | Analysis, code review, complex reasoning |
| `opus` | Critical decisions, architectural planning |

### Command Namespacing

Group related commands under one plugin:

```
/git:push
/git:push-pr
```

Not:

```
/push
/push-pr
```

## Common Mistakes

### 1. Version Mismatch

**Problem**: plugin.json shows v1.0.0, marketplace.json shows v1.1.0

**Solution**: Always update both files together. Use grep to verify:

```bash
grep -r "version" plugins/<name>/.claude-plugin/ .claude-plugin/marketplace.json
```

### 2. Missing Installation Section

**Problem**: Users don't know how to install the plugin

**Solution**: Always include standardized installation instructions:

```markdown
## Installation

\`\`\`bash
# 1. Add marketplace (first time only)
claude plugin marketplace add october-academy/claude-plugins

# 2. Update marketplace
claude plugin marketplace update

# 3. Install plugin
claude plugin install <plugin-name>@october-plugins

# 4. Restart Claude Code
\`\`\`
```

### 3. Overly Verbose Plugin Names

**Problem**: `/session-wrap` is harder to type than `/wrap`

**Solution**: Use short, memorable names. Reserve descriptive text for documentation.

### 4. Duplicate Functionality

**Problem**: Creating a new skill that overlaps with existing agents

**Solution**: Check existing plugins before creating new ones. Consider extending rather than duplicating.

### 5. Missing Hook Permissions

**Problem**: Hook script doesn't execute

**Solution**: Make scripts executable:

```bash
chmod +x plugins/<name>/hooks/*.sh
```

### 6. Hardcoded Paths

**Problem**: Scripts break on different machines

**Solution**: Use `${CLAUDE_PLUGIN_ROOT}` variable in hooks.json

## Testing

1. **Syntax Check**: Validate JSON files
   ```bash
   cat plugins/<name>/.claude-plugin/plugin.json | jq .
   ```

2. **Integration Test**: Install and run the plugin
   ```bash
   claude plugin install <name>
   ```

3. **Hook Test**: Verify hooks trigger correctly

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add your plugin following this guide
4. Update marketplace.json
5. Submit a pull request

## Questions?

- Check existing plugins for examples
- Review CLAUDE.md for project-specific conventions
- Open an issue for clarification
