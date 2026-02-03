---
name: push
description: 변경사항을 Conventional Commit 타입별로 자동 분류하여 여러 커밋으로 분리 후 push합니다. 메시지를 제공하면 단일 커밋으로 처리합니다.
user-invocable: true
disable-model-invocation: true
argument-hint: [message] [--branch <name>]
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git add:*), Bash(git reset:*), Bash(git commit:*), Bash(git branch:*), Bash(git log:*), Bash(git push:*), Bash(git switch:*), Bash(git fetch:*), Bash(git rev-parse:*), Bash(git show:*)
---

# /git:push — Git Multi-Commit & Push

변경사항을 Conventional Commit 타입별로 자동 분류하여 여러 커밋으로 분리한 뒤 push합니다. 메시지를 직접 제공하면 기존처럼 단일 커밋으로 처리합니다.

## 사용법

```text
/push [message] [--branch <name>]
```

- `[message]`를 제공하면 모든 변경사항을 단일 커밋으로 처리합니다.
- 메시지 없이 실행하면 타입별로 분류하여 여러 커밋을 생성합니다.
- `--branch <name>`로 푸시 대상 브랜치를 지정할 수 있습니다. 미지정 시 `main`으로 푸시합니다.

예시:

```text
/push                                            # 타입별 자동 분류 및 다중 커밋
/push "fix: correct auth header"                 # 단일 커밋
/push --branch feature/dark-mode                 # 타입별 자동 분류, feature 브랜치로 푸시
```

## 컨텍스트

- 현재 브랜치: !`git branch --show-current`
- 기본 브랜치 존재 여부: !`git rev-parse --verify main 2>/dev/null || echo missing`
- 변경 요약: !`git status --short`
- 변경된 파일 목록: !`git diff --name-status HEAD 2>/dev/null || git diff --name-status --cached`
- 최근 커밋(10개): !`git log --oneline -10`

## 작업 지시

### 1. 사전 확인

- 변경사항이 없는 경우 작업을 중단합니다.
- `$ARGUMENTS`에 메시지가 있으면(--branch 제외) **단일 커밋 모드**로 전환합니다 (섹션 6 참조).

### 2. 변경 파일 수집

스테이징된 파일이 있으면 스테이징된 파일만, 없으면 모든 변경 파일을 대상으로 합니다:

```bash
# 스테이징된 파일 확인
git diff --cached --name-status

# 스테이징 없으면 전체 변경 파일
git diff --name-status HEAD
```

### 3. 파일 타입 분류

각 파일을 다음 규칙에 따라 분류합니다 (우선순위 순서):

| 타입 | 분류 기준 |
|------|----------|
| `docs` | `*.md`, `docs/`, `README*`, `CHANGELOG*`, `LICENSE*` |
| `test` | `*.test.*`, `*.spec.*`, `__tests__/`, `test/`, `tests/` |
| `build` | `package.json`, `package-lock.json`, `tsconfig.*`, `vite.config.*`, `webpack.*`, `.github/`, `Dockerfile`, `docker-compose.*` |
| `chore` | `.gitignore`, `.*rc`, `.*rc.json`, `.claude*`, `.eslint*`, `.prettier*`, 기타 dotfile 설정 |
| `feat` | 새 파일 추가 (A 상태) - 위 규칙에 해당하지 않는 경우 |
| `refactor` | 파일 이동/이름 변경 (R 상태) |
| `fix` | 기존 파일 수정 (M 상태) - 기본값 |

**분류 로직**:
1. 파일 경로/이름 패턴 먼저 확인 (docs, test, build, chore)
2. 패턴에 해당하지 않으면 git 상태로 분류 (A→feat, R→refactor, M→fix)
3. 삭제된 파일(D)은 관련 타입 그룹에 포함 (같은 디렉토리의 다른 파일 타입 따라감, 없으면 chore)

### 4. 커밋 순서 및 실행

다음 순서로 각 타입별 커밋을 생성합니다 (빈 그룹 제외):

1. `build` - 빌드 설정
2. `feat` - 새 기능
3. `fix` - 버그 수정
4. `refactor` - 리팩토링
5. `test` - 테스트
6. `docs` - 문서
7. `chore` - 기타

각 그룹에 대해:

```bash
# 1. 해당 파일들만 스테이징
git add <file1> <file2> ...

# 2. 커밋 메시지 생성 및 커밋
git commit -m "<type>(<scope>): <subject>" -m "<body>"
```

**스코프 추론**:
- 그룹 내 파일들의 공통 상위 디렉토리가 있으면 스코프로 사용
- 예: `src/ui/Button.tsx`, `src/ui/Modal.tsx` → `feat(ui): ...`
- 공통 디렉토리가 없거나 루트면 스코프 생략

**커밋 메시지 규칙**:
- 형식: `<type>(<scope>): <subject>`
- 제한: 제목은 72자 이내, 명령형 현재형 사용, 마침표 생략
- 본문: `Changed N file(s) (+A/-D lines)`

### 5. 출력 형식

각 커밋 후 진행 상황을 표시합니다:

```
[1/3] docs: update README installation guide
      Changed 1 file (+15/-3 lines)

[2/3] feat(ui): add DarkModeToggle component
      Changed 2 files (+120/-0 lines)

[3/3] test(ui): add DarkModeToggle tests
      Changed 1 file (+45/-0 lines)

✓ 3 commits pushed to origin/main
```

### 6. 단일 커밋 모드 (메시지 제공 시)

`$ARGUMENTS`에 커밋 메시지가 있으면:

1. `git add -A`로 모든 변경사항 스테이징
2. 제공된 메시지로 단일 커밋
3. 푸시

### 7. 푸시

- 대상 브랜치 결정:
  - `$ARGUMENTS`에 `--branch <name>`가 있으면 `<name>` 사용
  - 그렇지 않으면 기본값 `main` 사용
- 현재 브랜치가 대상과 다르면:
  - 대상 브랜치 존재 시 `git switch <target>`
  - 미존재 시 `git switch -c <target>`
- `git push origin <target>` 실행
- upstream 미설정 시 `git push --set-upstream origin <target>` 시도

### 8. 결과 출력

```bash
# 생성된 커밋 확인
git log --oneline -<N>  # N = 생성된 커밋 수

# 상태 확인
git status --short
```

## 엣지 케이스

- **모든 파일이 같은 타입**: 단일 커밋으로 처리
- **스테이징된 파일 있음**: 스테이징된 파일만 대상으로 분류
- **삭제 파일만 있음**: `chore` 타입으로 처리
- **빈 그룹**: 건너뜀 (커밋 생성 안 함)

## 주의사항

- 이 커맨드는 저장소 루트에서 실행하는 것을 권장합니다.
- 푸시 대상 원격은 `origin`, 브랜치는 기본적으로 `main`입니다.
- 민감한 파일이나 대용량 파일이 의도치 않게 포함되지 않도록 커밋 전 `git status`를 확인하세요.

## 참고

- Skills 문서: [Claude Code Docs](https://code.claude.com/docs/en/skills)
- Conventional Commits: [conventionalcommits.org](https://www.conventionalcommits.org/)
