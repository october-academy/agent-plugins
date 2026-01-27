# Claude Plugins

Claude Code용 커스텀 플러그인 마켓플레이스입니다.

## 설치

```bash
# 마켓플레이스 추가 및 플러그인 설치
claude plugin marketplace add october-academy/claude-plugins
claude plugin marketplace update
claude plugin install <plugin-name>@october-plugins
```

## 호출 방식

플러그인 스킬/명령어는 **`/플러그인:스킬`** 형식으로 호출합니다.

```bash
/git:push              # git 플러그인의 push 명령어
/simplify:run          # simplify 플러그인의 run 스킬
/wrap:session          # wrap 플러그인의 session 스킬
```

> **왜 이런 형식인가요?**
> 플러그인 스킬은 다른 레벨(개인/프로젝트)의 스킬과 충돌을 방지하기 위해 `플러그인:스킬` 네임스페이스를 사용합니다.
> 자동 트리거 스킬은 Claude가 상황에 맞게 자동으로 호출합니다.

## 플러그인 목록

| 플러그인 | 설명 | 호출 방식 |
|---------|------|----------|
| [clarify](./plugins/clarify) | 모호한 요구사항을 명확한 명세로 변환 | `/clarify:start`, `/clarify:cancel` |
| [feature-dev](./plugins/feature-dev) | 7단계 체계적 기능 개발 워크플로우 | `/feature-dev:start` |
| [frontend-design](./plugins/frontend-design) | 고품질 프론트엔드 인터페이스 생성 | `/frontend-design:create` (자동) |
| [git](./plugins/git) | Git 커밋, 푸시, PR 자동화 | `/git:push`, `/git:push-pr` |
| [interview-prompt-builder](./plugins/interview-prompt-builder) | 요구사항 수집용 인터뷰 프롬프트 생성 | `/interview-prompt-builder:build` (자동) |
| [linear](./plugins/linear) | Linear 이슈 트래킹 통합 (MCP) | - |
| [simplify](./plugins/simplify) | 코드 단순화 및 정제 | `/simplify:run` |
| [typescript-lsp](./plugins/typescript-lsp) | TypeScript/JS 언어 서버 (MCP) | - |
| [web-perf-ux](./plugins/web-perf-ux) | 웹 성능 및 UX 최적화 분석 | `/web-perf-ux:analyze` (자동) |
| [wrap](./plugins/wrap) | 세션 마무리 및 문서화 | `/wrap:session` |

---

## 상세 설명

### clarify

모호한 요구사항을 구조화된 질문으로 명확화합니다.

```
/clarify:start "로그인 기능 추가"
/clarify:start "REST API 구축" --max-iterations 5
/clarify:cancel                    # 진행 중인 루프 취소
```

- 반복당 4개 질문 × 4개 옵션
- Before/After 요구사항 요약

---

### feature-dev

7단계 기능 개발: Discovery → Codebase Exploration → Clarifying Questions → Architecture Design → Implementation → Quality Review → Summary

```
/feature-dev:start OAuth 인증 추가
```

에이전트: `code-explorer`, `code-architect`, `code-reviewer`

---

### frontend-design

고품질 프론트엔드 UI 생성. 프론트엔드 작업 시 자동 적용.

- 독특한 타이포그래피/색상
- 하이 임팩트 애니메이션
- 프로덕션 레디 코드

---

### git

Git 커밋/푸시/PR 자동화. Conventional Commits 형식.

```
/git:push                              # 자동 메시지, main에 push
/git:push "fix: bug" --branch hotfix   # 특정 브랜치에 push
/git:push-pr                           # push 후 PR 생성
/git:push-pr "feat: new" --base dev    # dev 기준 PR
```

---

### interview-prompt-builder

Claude가 작업 전 요구사항을 수집하도록 인터뷰 프롬프트 생성.

트리거: "Help me write a prompt for...", "I'm not sure what I want yet"

---

### linear

Linear 이슈 트래킹 MCP 통합. 이슈 생성/관리, 상태 업데이트, 워크스페이스 검색.

---

### simplify

코드 단순화. 기능은 유지하고 구현만 개선.

```
/simplify:run                 # 최근 수정 코드
/simplify:run src/utils.ts    # 특정 파일
```

원칙: 명확성 > 간결성, 중첩 삼항 금지, Opus 모델

---

### typescript-lsp

TypeScript/JS 언어 서버 MCP. Go-to-definition, Find references, Error checking.

```bash
npm install -g typescript-language-server typescript
```

---

### web-perf-ux

웹 성능/UX 최적화. Lighthouse + Core Web Vitals 분석.

트리거: "성능 분석", "페이지가 느려요", "CLS 문제", "Lighthouse 실행"

---

### wrap

세션 마무리. 멀티 에이전트로 문서화, 자동화, 학습 포인트 분석.

```
/wrap:session                     # 인터랙티브 마무리
/wrap:session README 오타 수정     # 빠른 커밋
```

---

## 빠른 참조

### 슬래시 명령어

| 명령어 | 설명 |
|--------|------|
| `/clarify:start "<요구사항>"` | 요구사항 명확화 |
| `/clarify:cancel` | 진행 중인 clarify 루프 취소 |
| `/feature-dev:start <기능>` | 7단계 기능 개발 |
| `/frontend-design:create` | 프론트엔드 UI 생성 |
| `/git:push [msg] [--branch]` | 커밋 및 푸시 |
| `/git:push-pr [msg] [--base]` | 커밋, 푸시, PR |
| `/interview-prompt-builder:build` | 인터뷰 프롬프트 생성 |
| `/simplify:run [file]` | 코드 단순화 |
| `/web-perf-ux:analyze` | 웹 성능 분석 |
| `/wrap:session [msg]` | 세션 마무리 |

### 설치 명령어

```bash
claude plugin install clarify@october-plugins
claude plugin install feature-dev@october-plugins
claude plugin install frontend-design@october-plugins
claude plugin install git@october-plugins
claude plugin install interview-prompt-builder@october-plugins
claude plugin install linear@october-plugins
claude plugin install simplify@october-plugins
claude plugin install typescript-lsp@october-plugins
claude plugin install web-perf-ux@october-plugins
claude plugin install wrap@october-plugins
```

## 구조

```
claude-plugins/
├── .claude-plugin/
│   └── marketplace.json
├── plugins/
│   ├── clarify/
│   │   ├── .claude-plugin/plugin.json
│   │   ├── hooks/hooks.json
│   │   └── skills/{start,cancel}/
│   ├── feature-dev/
│   │   ├── .claude-plugin/plugin.json
│   │   ├── agents/{code-explorer,code-architect,code-reviewer}.md
│   │   └── commands/start.md
│   ├── frontend-design/
│   │   ├── .claude-plugin/plugin.json
│   │   └── skills/create/
│   ├── git/
│   │   ├── .claude-plugin/plugin.json
│   │   └── commands/{push,push-pr}.md
│   ├── interview-prompt-builder/
│   │   ├── .claude-plugin/plugin.json
│   │   └── skills/build/
│   ├── linear/
│   │   ├── .claude-plugin/plugin.json
│   │   └── .mcp.json
│   ├── simplify/
│   │   ├── .claude-plugin/plugin.json
│   │   ├── agents/{complexity-analyzer,pattern-checker,readability-analyzer,naming-reviewer,issue-simplifier}.md
│   │   └── skills/run/
│   ├── typescript-lsp/
│   │   └── .claude-plugin/plugin.json
│   ├── web-perf-ux/
│   │   ├── .claude-plugin/plugin.json
│   │   └── skills/analyze/
│   └── wrap/
│       ├── .claude-plugin/plugin.json
│       ├── agents/{doc-updater,automation-scout,learning-extractor,followup-suggester,duplicate-checker}.md
│       └── skills/session/
└── README.md
```

## 라이선스

MIT
