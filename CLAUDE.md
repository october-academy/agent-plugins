# CLAUDE.md

This repository is a small plugin marketplace. Only four plugins are currently maintained:

- `clarify`
- `cp`
- `blog-figure`
- `trend-scout`

## Useful Commands

```bash
# Validate marketplace metadata and plugin structure
./scripts/validate-plugins.sh

# Inspect marketplace JSON
jq . .claude-plugin/marketplace.json

# Inspect plugin metadata
jq . plugins/<name>/.claude-plugin/plugin.json
```

## Repository Layout

```text
plugins/<plugin-name>/
├── .claude-plugin/plugin.json
├── README.md
├── skills/<skill>/SKILL.md
└── hooks/hooks.json        # Optional
```

## Current Plugins

| Plugin | Contents | Trigger |
| --- | --- | --- |
| `clarify` | 3 skills + stop hook | `/clarify:vague`, `/clarify:unknown`, `/clarify:metamedium` |
| `cp` | 1 skill | `/cp` |
| `blog-figure` | 1 skill | `/blog-figure` |
| `trend-scout` | 1 skill | `/trend-scout` |

## Maintenance Notes

- Keep `plugin.json` and `.claude-plugin/marketplace.json` versions in sync.
- If the maintained plugin set changes, update `README.md`, this file, and `PLUGIN_DEVELOPMENT.md` together.
- Do not overwrite unrelated edits inside plugin worktrees; `trend-scout` content may be edited independently.
