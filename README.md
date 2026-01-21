# Claude Plugins

Claude Code용 커스텀 플러그인 마켓플레이스입니다.

## 설치 방법

```bash
# 1. 마켓플레이스 추가
claude plugin marketplace add october-academy/claude-plugins

# 2. 마켓플레이스 업데이트
claude plugin marketplace update

# 3. 플러그인 설치
claude plugin install <plugin-name>@october-plugins

# 4. Claude Code 재시작
```

## 사용 가능한 플러그인

### [clarify](./plugins/clarify)

모호한 요구사항을 구조화된 질문을 통해 정확한 명세로 변환합니다.

```bash
claude plugin install clarify@october-plugins
```

**사용법:**
```
/clarify "로그인 기능 추가"
/clarify "REST API 구축" --max-iterations 5
```

**특징:**
- 반복당 4개 질문 × 4개 옵션
- 기본 3회 반복 (--max-iterations로 조정)
- Before/After 요구사항 요약 출력

---

### [feature-dev](./plugins/feature-dev)

7단계 체계적 기능 개발 워크플로우입니다.

```bash
claude plugin install feature-dev@october-plugins
```

**사용법:**
```
/feature-dev OAuth 인증 추가
```

**7단계 워크플로우:**
1. Discovery - 요구사항 이해
2. Codebase Exploration - 기존 패턴 분석
3. Clarifying Questions - 모호함 해소
4. Architecture Design - 구현 방식 설계
5. Implementation - 구현
6. Quality Review - 코드 리뷰
7. Summary - 결과 문서화

**에이전트:**
- `code-explorer`: 코드베이스 분석
- `code-architect`: 아키텍처 설계
- `code-reviewer`: 코드 리뷰

---

### [session-wrap](./plugins/session-wrap)

세션 마무리 워크플로우입니다. 멀티 에이전트 분석으로 문서화, 자동화, 학습 포인트, 후속 작업을 제안합니다.

```bash
claude plugin install session-wrap@october-plugins
```

**사용법:**
```
/wrap                     # 인터랙티브 세션 마무리
/wrap README 오타 수정     # 빠른 커밋
```

**2-Phase 아키텍처:**
- Phase 1 (병렬): doc-updater, automation-scout, learning-extractor, followup-suggester
- Phase 2 (순차): duplicate-checker

---

### [frontend-design](./plugins/frontend-design)

고품질의 독창적인 프론트엔드 인터페이스를 생성합니다.

```bash
claude plugin install frontend-design@october-plugins
```

**특징:**
- 독특한 타이포그래피와 색상 팔레트
- 하이 임팩트 애니메이션
- 컨텍스트 인식 구현
- 프로덕션 레디 코드

**자동 적용:** Claude가 프론트엔드 작업 시 자동으로 이 스킬을 사용합니다.

---

### [code-simplifier](./plugins/code-simplifier)

코드를 명확성, 일관성, 유지보수성을 위해 단순화하고 정제합니다.

```bash
claude plugin install code-simplifier@october-plugins
```

**특징:**
- 기능 보존하면서 코드 개선
- 프로젝트 표준 적용
- 최근 수정된 코드에 집중
- Opus 모델 사용

**원칙:**
- 기능 변경 없음 - 구현 방식만 개선
- 중첩 삼항 연산자 피하기
- 명확성 > 간결성

---

### [typescript-lsp](./plugins/typescript-lsp)

TypeScript/JavaScript 언어 서버 설정 가이드입니다.

```bash
claude plugin install typescript-lsp@october-plugins
```

**기능:**
- Go-to-definition
- Find references
- Error checking

**설치:**
```bash
npm install -g typescript-language-server typescript
```

---

### [linear](./plugins/linear)

Linear 이슈 트래킹 통합입니다. MCP 서버를 통해 Linear와 연동합니다.

```bash
claude plugin install linear@october-plugins
```

**기능:**
- 이슈 생성 및 관리
- 프로젝트 관리
- 상태 업데이트
- 워크스페이스 검색

---

### [git](./plugins/git)

Git 커밋, 푸시, PR 생성 자동화 워크플로우입니다.

```bash
claude plugin install git@october-plugins
```

**사용법:**
```
# push 명령어
/git:push                                    # 자동 메시지 생성 후 main에 push
/git:push "fix: correct auth header"         # 지정된 메시지로 main에 push
/git:push "feat(ui): add toggle" --branch feature/dark-mode  # 특정 브랜치에 push

# push-pr 명령어
/git:push-pr                                         # 자동 메시지 생성, main 기준 PR 생성
/git:push-pr "fix: correct auth header"              # 지정된 메시지로 PR 생성
/git:push-pr "feat(ui): add DarkModeToggle" --base develop  # develop 기준 PR 생성
```

**특징:**
- Conventional Commits 형식 자동 생성
- `--branch <name>`으로 대상 브랜치 지정 (push)
- `--base <branch>`로 PR base 브랜치 지정 (push-pr)
- PR 본문 자동 생성 (Summary, Changes, Test plan)

---

### [interview-prompt-builder](./plugins/interview-prompt-builder)

Claude가 작업 전 요구사항을 수집하도록 하는 인터뷰 프롬프트를 생성합니다.

```bash
claude plugin install interview-prompt-builder@october-plugins
```

**트리거:**
- "Help me write a prompt for..."
- "Make an interview prompt"
- "I'm not sure what I want yet"

**워크플로우:**
1. 대상 작업 파악
2. 인터뷰 차원 식별 (Audience, Scope, Format, Constraints, Quality, Context)
3. 인터뷰 행동 정의
4. 구조화된 프롬프트 생성

---

## 빠른 참조

### 터미널 명령어 (CLI)

| 명령어 | 설명 |
|--------|------|
| `claude plugin marketplace add october-academy/claude-plugins` | 마켓플레이스 추가 |
| `claude plugin marketplace update` | 마켓플레이스 업데이트 |
| `claude plugin install clarify@october-plugins` | clarify 설치 |
| `claude plugin install feature-dev@october-plugins` | feature-dev 설치 |
| `claude plugin install session-wrap@october-plugins` | session-wrap 설치 |
| `claude plugin install frontend-design@october-plugins` | frontend-design 설치 |
| `claude plugin install code-simplifier@october-plugins` | code-simplifier 설치 |
| `claude plugin install typescript-lsp@october-plugins` | typescript-lsp 설치 |
| `claude plugin install linear@october-plugins` | linear 설치 |
| `claude plugin install git@october-plugins` | git 설치 |
| `claude plugin install interview-prompt-builder@october-plugins` | interview-prompt-builder 설치 |
| `claude plugin uninstall <name>` | 플러그인 제거 |

### 슬래시 명령어 (Claude Code 내부)

| 명령어 | 설명 |
|--------|------|
| `/clarify "<요구사항>"` | 요구사항 명확화 루프 시작 |
| `/cancel` | clarify 루프 취소 |
| `/feature-dev <기능>` | 7단계 기능 개발 시작 |
| `/wrap` | 세션 마무리 분석 |
| `/git:push [message] [--branch <name>]` | Git 커밋 및 푸시 |
| `/git:push-pr [message] [--base <branch>]` | Git 커밋, 푸시 및 PR 생성 |

## 마켓플레이스 구조

```
claude-plugins/
├── .claude-plugin/
│   └── marketplace.json
├── plugins/
│   ├── clarify/
│   ├── code-simplifier/
│   ├── feature-dev/
│   ├── frontend-design/
│   ├── interview-prompt-builder/
│   ├── linear/
│   ├── git/
│   ├── session-wrap/
│   └── typescript-lsp/
└── README.md
```

## 라이선스

MIT
