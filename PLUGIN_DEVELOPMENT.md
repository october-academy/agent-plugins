# Plugin Development Guide

이 저장소는 현재 `clarify`, `cp`, `blog-figure`, `trend-scout` 네 플러그인만 관리한다. 문서와 마켓플레이스를 작게 유지하는 것이 원칙이다.

## 기본 구조

```text
plugins/<plugin-name>/
├── .claude-plugin/
│   └── plugin.json
├── README.md
├── skills/
│   └── <skill>/SKILL.md
└── hooks/
    └── hooks.json          # 선택 사항
```

## 필수 파일

### `plugin.json`

```json
{
  "name": "plugin-name",
  "version": "1.0.0",
  "description": "Brief description",
  "author": { "name": "Author Name" }
}
```

### `SKILL.md`

```markdown
---
name: skill-name
description: Brief skill description
user-invocable: true
---

# Skill Name
```

### `README.md`

반드시 포함할 내용:

- 설치 방법
- 대표 호출 예시
- 핵심 동작 요약

## 마켓플레이스 등록

`.claude-plugin/marketplace.json`에 플러그인을 추가하거나 제거할 때는 다음을 같이 맞춘다.

1. 루트 `README.md`
2. `CLAUDE.md`
3. 해당 플러그인 폴더
4. 버전 일치 여부

예시 엔트리:

```json
{
  "name": "cp",
  "description": "커밋과 푸시를 한 번에 수행하는 단축 명령어",
  "version": "1.0.0",
  "author": { "name": "Yu Ho Gyun" },
  "source": "./plugins/cp",
  "category": "development"
}
```

## 변경 체크리스트

```bash
./scripts/validate-plugins.sh
jq . .claude-plugin/marketplace.json
jq . plugins/<name>/.claude-plugin/plugin.json
```

- 삭제된 플러그인을 가리키는 링크나 예시가 남지 않았는지 확인
- 루트 문서와 개별 플러그인 README가 같은 이름/호출 방식을 쓰는지 확인
- 훅 스크립트가 있으면 경로와 파일명이 실제 구조와 맞는지 확인

## 현재 유지 범위

- `clarify`: multi-skill clarification plugin
- `cp`: commit/push shortcut
- `blog-figure`: blog image generation
- `trend-scout`: trend research and curation
