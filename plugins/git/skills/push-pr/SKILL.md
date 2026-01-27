---
name: push-pr
description: 변경사항을 커밋하고 push한 뒤 GitHub PR을 자동 생성합니다. 메시지를 생략하면 자동 생성하며, --base로 base 브랜치를 지정할 수 있습니다.
argument-hint: [message] [--base <branch>]
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git add:*), Bash(git reset:*), Bash(git commit:*), Bash(git branch:*), Bash(git log:*), Bash(git push:*), Bash(git switch:*), Bash(git fetch:*), Bash(git rev-parse:*), Bash(gh pr create:*), Bash(gh pr list:*)
---

# /git:push-pr — Git Commit, Push & Create PR

변경사항을 분석해 의미 있는 커밋 메시지를 생성(또는 전달받은 메시지 사용)하고, 현재 브랜치에 push한 뒤 GitHub Pull Request를 자동 생성합니다. 기본 base 브랜치는 `main`이며, `--base <branch>`로 변경할 수 있습니다. 참조: [Anthropic: Custom slash commands](https://docs.anthropic.com/en/docs/claude-code/slash-commands#custom-slash-commands)

## 사용법

```text
/push-pr [message] [--base <branch>]
```

- `[message]`를 제공하면 해당 내용을 커밋 제목 및 PR 제목으로 사용합니다.
- `--base <branch>`로 PR의 base 브랜치를 지정할 수 있습니다. 미지정 시 `main`으로 설정합니다.
- 인자가 없으면 변경사항을 요약하여 Conventional Commits 규칙에 맞춘 메시지를 자동 생성합니다.

예시:

```text
/push-pr
/push-pr "fix: correct auth header"
/push-pr "feat(ui): add DarkModeToggle" --base develop
```

## 컨텍스트

- 현재 브랜치: !`git branch --show-current`
- 기본 브랜치 존재 여부: !`git rev-parse --verify main 2>/dev/null || echo missing`
- 변경 요약: !`git status --short`
- 변경 통계: !`git diff --stat`
- 최근 커밋(10개): !`git log --oneline -10`
- 브랜치와 origin 비교: !`git log --oneline origin/$(git branch --show-current)..HEAD 2>/dev/null || echo "no-upstream"`

## 작업 지시

아래 요구사항을 충족하도록 커밋/푸시/PR 생성을 수행하세요.

1. 준비

- 현재 브랜치가 `main` 또는 `master`인 경우 작업을 중단하고 경고합니다. (main에서는 직접 PR을 만들 수 없습니다)
- 변경사항이 없는 경우 작업을 중단합니다.
- 스테이징이 비어 있으면 `git add -A`로 전체 변경을 스테이징합니다.

2. 커밋 메시지

- `$ARGUMENTS`에서 `--base` 옵션을 제외한 부분을 커밋 메시지로 사용합니다.
- 메시지가 비어 있으면 변경사항을 바탕으로 Conventional Commits 규칙에 맞춘 제목을 자동 생성합니다.
  - 형식: `<type>(<scope>): <subject>`
  - 제한: 제목은 72자 이내, 명령형 현재형 사용, 마침표 생략
  - 타입 예시: feat, fix, refactor, docs, chore, test, build
  - 스코프 예시: ui, pages, auth, deps, docs 등 변경 경로에 따라 합리적으로 추론
- 본문(둘째 블록)은 간결한 요약과 변경 통계를 포함합니다. 예: `Changed N files (+A/-D lines)`

3. 커밋 실행

- `git commit -m <subject> -m <body>`로 커밋합니다.

4. 푸시

- 현재 브랜치를 `git push origin <current-branch>`로 푸시합니다.
- upstream 미설정 등으로 실패할 경우 `git push --set-upstream origin <current-branch>`를 시도합니다.

5. PR 생성

- base 브랜치 결정 로직:
  - `$ARGUMENTS`에 `--base <branch>`가 있으면 `<branch>`를 사용합니다.
  - 그렇지 않으면 기본값으로 `main`을 사용합니다.
- PR 제목: 커밋 메시지의 첫 줄과 동일하게 사용합니다.
- PR 본문: 다음 형식으로 자동 생성합니다:
  ```
  ## Summary
  <변경사항 요약을 2-3개 bullet point로 작성>

  ## Changes
  <변경된 파일과 통계 요약>

  ## Test plan
  - [ ] 로컬에서 테스트 완료
  - [ ] 빌드 성공 확인
  ```
- `gh pr create --title "<title>" --base <base-branch> --body "<body>"`로 PR을 생성합니다.
- PR이 이미 존재하는 경우 에러를 무시하고 기존 PR URL을 안내합니다.

6. 결과 출력

- 생성된 PR URL을 출력합니다.
- 최신 커밋 한 줄 요약: !`git log --oneline -1`
- 상태 요약: !`git status --short`

## 주의사항

- 이 커맨드는 저장소 루트에서 실행하는 것을 권장합니다.
- `gh` CLI가 설치되어 있고 인증되어 있어야 합니다. (`gh auth status`로 확인)
- main/master 브랜치에서는 실행할 수 없습니다. feature 브랜치에서 실행하세요.
- 민감한 파일이나 대용량 파일이 의도치 않게 포함되지 않도록 커밋 전 `git status`를 반드시 확인하세요.

## 참고

- Custom Slash Commands 사양: [Anthropic 문서](https://docs.anthropic.com/en/docs/claude-code/slash-commands#custom-slash-commands)
- GitHub CLI 문서: [GitHub CLI](https://cli.github.com/)
