# Git Plugin

Git 변경사항을 스테이징하고 Conventional Commits 형식의 커밋 메시지를 생성한 뒤 원격 저장소에 푸시하는 워크플로우를 제공합니다. PR 생성까지 한 번에 처리할 수도 있습니다.

## Overview

Git Plugin은 일상적인 Git 커밋 및 푸시 작업을 간소화합니다. 변경사항을 분석하여 의미 있는 커밋 메시지를 자동 생성하고, 지정된 브랜치로 푸시합니다.

## Commands

### `/git:push`

변경사항을 커밋하고 원격 저장소에 푸시합니다.

**Usage:**

```bash
/git:push                                    # 자동 메시지 생성 후 main에 push
/git:push "fix: correct auth header"         # 지정된 메시지로 main에 push
/git:push "feat(ui): add toggle" --branch feature/dark-mode  # 특정 브랜치에 push
```

**Features:**
- Conventional Commits 형식 자동 생성
- `--branch <name>`으로 대상 브랜치 지정
- 브랜치 자동 전환/생성
- upstream 미설정 시 자동 설정

---

### `/git:push-pr`

변경사항을 커밋하고 push한 뒤 GitHub Pull Request를 자동 생성합니다.

**Usage:**

```bash
/git:push-pr                                         # 자동 메시지 생성, main 기준 PR 생성
/git:push-pr "fix: correct auth header"              # 지정된 메시지로 PR 생성
/git:push-pr "feat(ui): add DarkModeToggle" --base develop  # develop 기준 PR 생성
```

**Features:**
- Conventional Commits 형식 자동 생성
- `--base <branch>`로 PR의 base 브랜치 지정 (기본값: main)
- PR 본문 자동 생성 (Summary, Changes, Test plan)
- 이미 PR이 존재하면 기존 PR URL 안내

**Requirements:**
- `gh` CLI 설치 및 인증 필요 (`gh auth status`로 확인)
- main/master 브랜치에서는 실행 불가 (feature 브랜치에서 실행)

---

## Common Features

### Automatic Commit Message Generation

인자 없이 실행하면 변경사항을 분석하여 Conventional Commits 규칙에 맞는 커밋 메시지를 자동 생성합니다.

- **형식**: `<type>(<scope>): <subject>`
- **타입**: feat, fix, refactor, docs, chore, test, build
- **스코프**: 변경 경로에 따라 자동 추론 (ui, pages, auth 등)

### Workflow

1. **준비**: 변경사항 확인, 스테이징이 비어 있으면 전체 변경 스테이징
2. **커밋 메시지**: 사용자 제공 메시지 사용 또는 자동 생성
3. **커밋**: `git commit`으로 변경사항 커밋
4. **푸시**: 대상 브랜치로 푸시 (필요 시 브랜치 전환/생성)
5. **PR 생성** (push-pr만): GitHub PR 자동 생성
6. **결과 출력**: 최신 커밋 및 상태 요약 표시

## When to Use

| Command | Use Case |
|---------|----------|
| `/git:push` | 일상적인 커밋 및 푸시, 커밋 메시지 작성이 번거로울 때 |
| `/git:push-pr` | feature 브랜치 작업 완료 후 PR까지 한 번에 처리할 때 |

**Don't use for:**
- 복잡한 Git 작업 (rebase, merge 등)
- 세밀한 커밋 분리가 필요할 때
- 민감한 파일이 포함될 수 있는 경우 (먼저 `git status` 확인)

## Requirements

- Claude Code installed
- Git repository initialized
- Remote `origin` configured
- `gh` CLI (push-pr 명령어용)

## Caution

- 푸시 전 `git status`로 민감한 파일이나 대용량 파일이 포함되지 않았는지 확인하세요
- 기본 푸시 대상은 `origin main`입니다
- push-pr은 main/master 브랜치에서 실행할 수 없습니다

## Version

1.1.0
