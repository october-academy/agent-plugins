# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Claude Code 플러그인 마켓플레이스입니다. 각 플러그인은 `/plugins/<plugin-name>/` 디렉토리에 위치합니다.

## Plugin Structure

각 플러그인은 다음 구조를 따릅니다:

```
plugins/<plugin-name>/
├── .claude-plugin/
│   └── plugin.json          # 플러그인 메타데이터 (name, version, description, author)
├── README.md                # 플러그인 문서
├── commands/                # 슬래시 커맨드 정의 (optional)
│   └── <command>.md
├── skills/                  # 스킬 정의 (optional)
│   └── <skill>/
│       └── SKILL.md
├── agents/                  # 에이전트 정의 (optional)
│   └── <agent>.md
└── hooks/                   # 훅 정의 (optional)
```

## Creating a New Plugin

1. `plugins/<plugin-name>/` 디렉토리 생성
2. `.claude-plugin/plugin.json` 작성 (필수)
3. `README.md` 작성 (필수)
4. 필요에 따라 `commands/`, `skills/`, `agents/` 추가
5. `.claude-plugin/marketplace.json`의 `plugins` 배열에 새 플러그인 등록

### plugin.json 형식

```json
{
  "name": "plugin-name",
  "version": "1.0.0",
  "description": "Plugin description",
  "author": {
    "name": "Author Name"
  }
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
  "category": "productivity"  // or "development"
}
```

## Command Files (.md)

`commands/<command>.md` 파일은 frontmatter로 시작합니다:

```markdown
---
description: Command description
argument-hint: [optional arguments]
allowed-tools: Bash(git:*), Read, Edit  # optional tool restrictions
---

# Command instructions...
```

## Existing Plugins Reference

- **clarify**: 요구사항 명확화 (skills, hooks 사용)
- **feature-dev**: 7단계 기능 개발 워크플로우 (commands, agents 사용)
- **session-wrap**: 세션 마무리 분석 (commands, skills, agents 사용)
- **git**: Git commit & push 자동화 (commands 사용)
- **frontend-design**: 프론트엔드 UI 생성 (skills 사용)
- **code-simplifier**: 코드 단순화 (agents 사용)
