# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Claude Code 플러그인 마켓플레이스. 각 플러그인은 `/plugins/<plugin-name>/`에 위치.

## Plugin Structure

```
plugins/<plugin-name>/
├── .claude-plugin/
│   └── plugin.json          # 필수: 메타데이터
├── README.md                # 필수: 문서
├── commands/<cmd>.md        # 슬래시 커맨드 (/plugin:cmd)
├── skills/<skill>/SKILL.md  # 스킬 (자동 또는 /plugin:skill)
├── agents/<agent>.md        # 에이전트 (Task tool로 호출)
├── hooks/hooks.json         # 훅 정의
└── .mcp.json                # MCP 서버 설정
```

## Creating a New Plugin

1. `plugins/<name>/` 디렉토리 생성
2. `.claude-plugin/plugin.json` 작성
3. `README.md` 작성
4. commands/, skills/, agents/ 중 필요한 것 추가
5. `.claude-plugin/marketplace.json`에 등록

### plugin.json

```json
{
  "name": "plugin-name",
  "version": "1.0.0",
  "description": "Plugin description",
  "author": { "name": "Author Name" }
}
```

### marketplace.json 등록

```json
{
  "name": "plugin-name",
  "description": "Plugin description",
  "version": "1.0.0",
  "author": { "name": "Author Name" },
  "source": "./plugins/plugin-name",
  "category": "productivity"
}
```

## File Formats

### commands/<cmd>.md

```markdown
---
description: Command description
argument-hint: [optional arguments]
allowed-tools: Bash(git:*), Read, Edit
---

# Command instructions...
```

### skills/<skill>/SKILL.md

```markdown
---
description: Skill description
user-invocable: true
argument-hint: [optional arguments]
---

# Skill instructions...
```

### agents/<agent>.md

```markdown
---
name: agent-name
description: Agent description
model: opus  # or sonnet, haiku
---

# Agent instructions...
```

## Existing Plugins

| 플러그인 | 타입 | 트리거 |
|---------|------|--------|
| clarify | skills, hooks | `/clarify` |
| feature-dev | commands, agents | `/feature-dev` |
| frontend-design | skills | 자동 |
| git | commands | `/git:push`, `/git:push-pr` |
| interview-prompt-builder | skills | 자동 |
| linear | mcp | - |
| simplify | skills, agents | `/simplify` |
| typescript-lsp | mcp | - |
| web-perf-ux | skills | 자동 |
| wrap | commands, skills, agents | `/wrap` |
