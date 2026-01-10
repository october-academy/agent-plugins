# Claude Plugins

A marketplace of custom plugins for Claude Code.

## Installation

### 1. Add Marketplace

```bash
/plugin marketplace add zettalyst/claude-plugins
```

### 2. Update Marketplace

```bash
/plugin marketplace update
```

### 3. Install Plugin

```bash
/plugin install clarify-ralph@zettalyst-plugins
```

## Available Plugins

### [clarify-ralph](./plugins/clarify-ralph)

Iterative requirement clarification using AskUserQuestion in a Ralph Wiggum-style loop.

**Usage:**
```bash
/clarify-ralph "Add a login feature" --max-iterations 10
```

Transform vague requirements into precise specifications through structured questioning.

**Features:**
- One question at a time using AskUserQuestion
- User-controlled completion via "Clarification complete" option
- Max iterations safety limit
- Before/After requirement summary output

## Quick Reference

| Command | Description |
|---------|-------------|
| `/plugin marketplace add zettalyst/claude-plugins` | Add this marketplace |
| `/plugin marketplace update` | Update marketplace cache |
| `/plugin install clarify-ralph@zettalyst-plugins` | Install clarify-ralph |
| `/plugin uninstall clarify-ralph` | Uninstall plugin |

## Marketplace Structure

```
claude-plugins/
├── .claude-plugin/
│   └── marketplace.json    # Marketplace manifest
├── plugins/
│   └── clarify-ralph/      # Plugin directory
│       ├── .claude-plugin/
│       │   └── plugin.json
│       ├── commands/
│       ├── hooks/
│       ├── scripts/
│       └── README.md
└── README.md
```

## Contributing

1. Fork this repository
2. Create your plugin in `plugins/<your-plugin-name>/`
3. Add entry to `.claude-plugin/marketplace.json`
4. Submit a pull request

## License

MIT
