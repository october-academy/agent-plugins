# Claude Plugins

Claude Code용 커스텀 플러그인 마켓플레이스입니다.

## 설치

```bash
# 마켓플레이스 추가 및 플러그인 설치
claude plugin marketplace add october-academy/claude-plugins
claude plugin marketplace update
claude plugin install <plugin-name>@october-plugins
```

## 플러그인 목록

| 플러그인 | 설명 | 트리거 |
|---------|------|--------|
| [clarify](./plugins/clarify) | 모호한 요구사항을 명확한 명세로 변환 | `/clarify` |
| [feature-dev](./plugins/feature-dev) | 7단계 체계적 기능 개발 워크플로우 | `/feature-dev` |
| [frontend-design](./plugins/frontend-design) | 고품질 프론트엔드 인터페이스 생성 | 자동 |
| [git](./plugins/git) | Git 커밋, 푸시, PR 자동화 | `/git:push`, `/git:push-pr` |
| [interview-prompt-builder](./plugins/interview-prompt-builder) | 요구사항 수집용 인터뷰 프롬프트 생성 | 자동 |
| [linear](./plugins/linear) | Linear 이슈 트래킹 통합 (MCP) | - |
| [simplify](./plugins/simplify) | 코드 단순화 및 정제 | `/simplify` |
| [typescript-lsp](./plugins/typescript-lsp) | TypeScript/JS 언어 서버 (MCP) | - |
| [web-perf-ux](./plugins/web-perf-ux) | 웹 성능 및 UX 최적화 분석 | 자동 |
| [wrap](./plugins/wrap) | 세션 마무리 및 문서화 | `/wrap` |

---

## 상세 설명

### clarify

모호한 요구사항을 구조화된 질문으로 명확화합니다.

```
/clarify "로그인 기능 추가"
/clarify "REST API 구축" --max-iterations 5
```

- 반복당 4개 질문 × 4개 옵션
- Before/After 요구사항 요약

---

### feature-dev

7단계 기능 개발: Discovery → Codebase Exploration → Clarifying Questions → Architecture Design → Implementation → Quality Review → Summary

```
/feature-dev OAuth 인증 추가
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
/simplify                 # 최근 수정 코드
/simplify src/utils.ts    # 특정 파일
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
/wrap                     # 인터랙티브 마무리
/wrap README 오타 수정     # 빠른 커밋
```

---

## 빠른 참조

### 슬래시 명령어

| 명령어 | 설명 |
|--------|------|
| `/clarify "<요구사항>"` | 요구사항 명확화 |
| `/feature-dev <기능>` | 7단계 기능 개발 |
| `/git:push [msg] [--branch]` | 커밋 및 푸시 |
| `/git:push-pr [msg] [--base]` | 커밋, 푸시, PR |
| `/simplify [file]` | 코드 단순화 |
| `/wrap [msg]` | 세션 마무리 |

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
│   │   └── skills/{clarify,cancel}/
│   ├── feature-dev/
│   │   ├── .claude-plugin/plugin.json
│   │   ├── agents/{code-explorer,code-architect,code-reviewer}.md
│   │   └── commands/feature-dev.md
│   ├── frontend-design/
│   │   ├── .claude-plugin/plugin.json
│   │   └── skills/frontend-design/
│   ├── git/
│   │   ├── .claude-plugin/plugin.json
│   │   └── commands/{push,push-pr}.md
│   ├── interview-prompt-builder/
│   │   ├── .claude-plugin/plugin.json
│   │   └── skills/interview-prompt-builder/
│   ├── linear/
│   │   ├── .claude-plugin/plugin.json
│   │   └── .mcp.json
│   ├── simplify/
│   │   ├── .claude-plugin/plugin.json
│   │   ├── agents/simplify.md
│   │   └── skills/simplify/
│   ├── typescript-lsp/
│   │   └── .claude-plugin/plugin.json
│   ├── web-perf-ux/
│   │   ├── .claude-plugin/plugin.json
│   │   └── skills/web-perf-ux/
│   └── wrap/
│       ├── .claude-plugin/plugin.json
│       ├── agents/{doc-updater,automation-scout,learning-extractor,followup-suggester,duplicate-checker}.md
│       ├── commands/wrap.md
│       └── skills/wrap/
└── README.md
```

## 라이선스

MIT
