---
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git add:*), Bash(git reset:*), Bash(git commit:*), Bash(git branch:*), Bash(git log:*), Bash(git push:*), Bash(git switch:*), Bash(git fetch:*), Bash(git rev-parse:*)
argument-hint: [message] [--branch <name>]
description: 변경사항을 스테이징하고 Conventional Commits 메시지로 커밋한 뒤 기본적으로 origin main으로 push합니다. 메시지를 생략하면 자동 생성하며, --branch로 대상 브랜치를 지정할 수 있습니다.
---

# /push — Git Commit & Push (Custom Slash Command)

변경사항을 분석해 의미 있는 커밋 메시지를 생성(또는 전달받은 메시지 사용)하고, 기본값으로 `origin main`에 push합니다. 필요 시 `--branch <name>`로 대상을 지정할 수 있습니다. 이 커맨드는 Claude Code의 Custom Slash Command 형식을 따릅니다. 참조: [Anthropic: Custom slash commands](https://docs.anthropic.com/en/docs/claude-code/slash-commands#custom-slash-commands)

## 사용법

```text
/push [message] [--branch <name>]
```

- `[message]`를 제공하면 해당 내용을 커밋 제목으로 사용합니다.
- `--branch <name>`로 푸시 대상 브랜치를 지정할 수 있습니다. 미지정 시 `main`으로 푸시합니다.
- 인자가 없으면 변경사항을 요약하여 Conventional Commits 규칙에 맞춘 메시지를 자동 생성합니다.

예시:

```text
/push
/push "fix: correct auth header"
/push "feat(ui): add DarkModeToggle" --branch feature/dark-mode
```

## 컨텍스트

- 현재 브랜치: !`git branch --show-current`
- 기본 브랜치 존재 여부: !`git rev-parse --verify main 2>/dev/null || echo missing`
- 변경 요약: !`git status --short`
- 변경 통계: !`git diff --stat`
- 최근 커밋(10개): !`git log --oneline -10`

## 작업 지시

아래 요구사항을 충족하도록 커밋/푸시를 수행하세요.

1. 준비

- 변경사항이 없는 경우 작업을 중단합니다.
- 스테이징이 비어 있으면 `git add -A`로 전체 변경을 스테이징합니다.

2. 커밋 메시지

- `$ARGUMENTS`가 비어 있지 않으면 이를 커밋 제목(첫 줄)으로 사용합니다.
- 비어 있으면 변경사항을 바탕으로 Conventional Commits 규칙에 맞춘 제목을 자동 생성합니다.
  - 형식: `<type>(<scope>): <subject>`
  - 제한: 제목은 72자 이내, 명령형 현재형 사용, 마침표 생략
  - 타입 예시: feat, fix, refactor, docs, chore, test, build
  - 스코프 예시: ui, pages, auth, deps, docs 등 변경 경로에 따라 합리적으로 추론
- 본문(둘째 블록)은 간결한 요약과 변경 통계를 포함합니다. 예: `Changed N files (+A/-D lines)`

3. 커밋 실행

- `git commit -m <subject> -m <body>`로 커밋합니다.

4. 푸시

- 대상 브랜치 결정 로직
  - `$ARGUMENTS`에 `--branch <name>`가 있으면 `<name>`을 사용합니다.
  - 그렇지 않으면 기본값으로 `main`을 사용합니다.
- 현재 체크아웃이 대상 브랜치가 아닌 경우
  - 대상 브랜치가 존재하면 `git switch <target>` 후 푸시합니다.
  - 존재하지 않으면 `git switch -c <target>`로 생성 후 푸시합니다.
- `git push origin <target>`을 실행합니다.
- upstream 미설정 등으로 실패할 경우 `git push --set-upstream origin <target>`를 시도합니다.

5. 결과 출력

- 최신 커밋 한 줄 요약: !`git log --oneline -1`
- 상태 요약: !`git status --short`

## 주의사항

- 이 커맨드는 저장소 루트에서 실행하는 것을 권장합니다.
- 푸시 대상 원격은 `origin`, 브랜치는 기본적으로 `main`입니다. `--branch <name>`로 변경할 수 있습니다.
- 민감한 파일이나 대용량 파일이 의도치 않게 포함되지 않도록 커밋 전 `git status`를 반드시 확인하세요.

## 참고

- Custom Slash Commands 사양: [Anthropic 문서](https://docs.anthropic.com/en/docs/claude-code/slash-commands#custom-slash-commands)
