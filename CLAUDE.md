# CLAUDE.md

This repository is a small plugin marketplace. Only five plugins are currently maintained:

- `clarify`
- `cp`
- `blog-figure`
- `blog-humanize-fast`
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
| `clarify` | 3 skills + stop hook | `/clarify:interview`, `/clarify:unknown`, `/clarify:metamedium` |
| `cp` | 1 skill | `/cp` |
| `blog-figure` | 1 skill | `/blog-figure` |
| `blog-humanize-fast` | 1 skill + bundled workflow | `/blog-humanize-fast` |
| `trend-scout` | 1 skill | `/trend-scout` |

## Maintenance Notes

- Keep `plugin.json` and `.claude-plugin/marketplace.json` versions in sync.
- If the maintained plugin set changes, update `README.md`, this file, and `PLUGIN_DEVELOPMENT.md` together.
- Do not overwrite unrelated edits inside plugin worktrees; `trend-scout` content may be edited independently.

## Codex Compatibility

This marketplace doubles as a Codex plugin marketplace — Codex CLI (0.144+) reads
`.claude-plugin/marketplace.json` as-is (`codex plugin marketplace add`, then
`codex plugin add <name>@agent-plugins`). When editing plugins, keep these rules:

- Codex loads `skills/`, `hooks/hooks.json` (Claude-style events incl. `Stop` with the
  `decision: block` protocol), and `.mcp.json`. It does not load `commands/` or `agents/`.
  `${CLAUDE_PLUGIN_ROOT}` resolves on both runtimes.
- Skills that use Claude-only tools must state a runtime fallback in SKILL.md
  (`AskUserQuestion` → Codex `request_user_input` → plain numbered list; `Workflow`-dependent
  skills declare themselves Claude Code-only). See PLUGIN_DEVELOPMENT.md for the full policy.
- Bump the plugin version on content changes: Codex snapshots installs under
  `~/.codex/plugins/cache/agent-plugins/<plugin>/<version>`, so a same-version change
  only lands after `codex plugin remove <name>` + `codex plugin add`.
