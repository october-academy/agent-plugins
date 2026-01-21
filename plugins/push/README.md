# Push Plugin

Git 변경사항을 스테이징하고 Conventional Commits 형식의 커밋 메시지를 생성한 뒤 원격 저장소에 푸시하는 워크플로우를 제공합니다.

## Overview

Push Plugin은 일상적인 Git 커밋 및 푸시 작업을 간소화합니다. 변경사항을 분석하여 의미 있는 커밋 메시지를 자동 생성하고, 지정된 브랜치로 푸시합니다.

## Command: `/push`

변경사항을 커밋하고 원격 저장소에 푸시합니다.

**Usage:**

```bash
/push                                    # 자동 메시지 생성 후 main에 push
/push "fix: correct auth header"         # 지정된 메시지로 main에 push
/push "feat(ui): add toggle" --branch feature/dark-mode  # 특정 브랜치에 push
```

## Features

### Automatic Commit Message Generation

인자 없이 실행하면 변경사항을 분석하여 Conventional Commits 규칙에 맞는 커밋 메시지를 자동 생성합니다.

- **형식**: `<type>(<scope>): <subject>`
- **타입**: feat, fix, refactor, docs, chore, test, build
- **스코프**: 변경 경로에 따라 자동 추론 (ui, pages, auth 등)

### Flexible Branch Targeting

`--branch <name>` 옵션으로 푸시 대상 브랜치를 지정할 수 있습니다. 미지정 시 기본값은 `main`입니다.

### Smart Branch Handling

- 현재 브랜치가 대상 브랜치와 다른 경우 자동으로 전환
- 대상 브랜치가 존재하지 않으면 새로 생성
- upstream 미설정 시 자동으로 설정

## Workflow

1. **준비**: 변경사항 확인, 스테이징이 비어 있으면 전체 변경 스테이징
2. **커밋 메시지**: 사용자 제공 메시지 사용 또는 자동 생성
3. **커밋**: `git commit`으로 변경사항 커밋
4. **푸시**: 대상 브랜치로 푸시 (필요 시 브랜치 전환/생성)
5. **결과 출력**: 최신 커밋 및 상태 요약 표시

## When to Use

**Use for:**
- 일상적인 커밋 및 푸시 작업
- 커밋 메시지 작성이 번거로울 때
- 여러 변경사항을 한 번에 정리할 때

**Don't use for:**
- 복잡한 Git 작업 (rebase, merge 등)
- 세밀한 커밋 분리가 필요할 때
- 민감한 파일이 포함될 수 있는 경우 (먼저 `git status` 확인)

## Requirements

- Claude Code installed
- Git repository initialized
- Remote `origin` configured

## Caution

- 푸시 전 `git status`로 민감한 파일이나 대용량 파일이 포함되지 않았는지 확인하세요
- 기본 푸시 대상은 `origin main`입니다

## Version

1.0.0
