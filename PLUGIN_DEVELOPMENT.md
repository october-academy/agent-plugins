# Plugin Development Guide

이 저장소는 현재 `clarify`, `cp`, `blog-figure`, `blog-humanize-fast`, `trend-scout` 다섯 플러그인만 관리한다. 문서와 마켓플레이스를 작게 유지하는 것이 원칙이다.

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

`user-invocable: true`는 이 저장소의 모든 스킬이 쓰는 표준이다 — 새 스킬을 추가할 때
빠뜨리지 않는다.

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
- description 파리티: `plugin.json`의 `description`과 `marketplace.json` 해당 엔트리의
  `description`이 글자 그대로 일치하는지 확인

## Codex 호환성

이 마켓플레이스는 Claude Code와 Codex CLI(0.144+ `codex plugin`)를 함께 지원한다.
Codex는 `.claude-plugin/marketplace.json`과 플러그인 디렉토리 구조를 그대로 읽으므로
별도 포맷 변환이 없다. 대신 플러그인을 작성/수정할 때 아래 차이를 지킨다.

- **로드 범위**: Codex는 `skills/`, `hooks/hooks.json`, `.mcp.json`을 로드한다.
  `commands/`와 `agents/`는 로드하지 않으므로 기능은 스킬로 담는다.
- **스킬 이름**: Codex에서 스킬은 `플러그인:스킬`(예: `clarify:interview`)로 등록되고,
  슬래시 커맨드 대신 프롬프트에서 이름을 지목해 호출한다.
- **훅**: `PreToolUse` `PermissionRequest` `PostToolUse` `PreCompact` `PostCompact`
  `SessionStart` `UserPromptSubmit` `SubagentStart` `SubagentStop` `Stop` 이벤트를
  Codex도 지원하며, Stop 훅의 `{"decision":"block","reason":...}` 응답과 stdin JSON
  (`session_id`/`cwd`/`transcript_path`)도 동일하다. 단 assistant 마지막 발화는
  Claude Code에선 transcript JSONL 파싱, Codex에선 stdin의 `last_assistant_message`
  필드로 읽어야 한다 — `clarify/hooks/stop-hook.sh`가 두 경로를 모두 처리하는 예시다.
- **플러그인 루트 변수**: `${CLAUDE_PLUGIN_ROOT}`는 Codex에서도 해석된다
  (`PLUGIN_ROOT`와 동일 값).
- **Claude 전용 도구 폴백**: 스킬 본문이 Claude 전용 도구에 의존하면 SKILL.md에
  런타임 폴백을 명시한다. 관례 — `AskUserQuestion` → Codex `request_user_input` →
  번호 목록 텍스트. `Workflow` 의존 스킬(blog-humanize-fast)은 Codex 미지원임을
  본문에 선언한다.
- **버전 규율**: 버전은 strict semver로 유지한다. Codex 설치본은
  `~/.codex/plugins/cache/<marketplace>/<plugin>/<version>` 버전 키 스냅샷이라,
  내용이 바뀌면 버전을 올려야 새로 뜬다. 같은 버전 재반영은
  `codex plugin remove <name>` 후 `codex plugin add <name>@agent-plugins`.

로컬 검증 절차:

```bash
codex plugin marketplace add /path/to/agent-plugins
codex plugin list            # agent-plugins 섹션에 5개 플러그인 확인
codex plugin add <name>@agent-plugins
```

## 현재 유지 범위

- `clarify`: multi-skill clarification plugin
- `cp`: commit/push shortcut
- `blog-figure`: blog image generation
- `blog-humanize-fast`: fast conservative blog prose humanization
- `trend-scout`: trend research and curation
