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

플러그인 스킬은 **단축형** `/플러그인명`으로 호출합니다.

```bash
/clarify               # 요구사항 명확화
/simplify              # 코드 단순화
/wrap                  # 세션 마무리
/feature-dev           # 기능 개발 워크플로우
/git:push              # git push (다중 명령어 플러그인)
```

> **단축형 조건**: 플러그인에 스킬이 1개이고, 스킬 이름 = 플러그인 이름이면 단축형 사용 가능
> git 플러그인은 2개 명령어(push, push-pr)가 있어 `/git:명령어` 형식 사용

## 플러그인 목록

| 플러그인 | 설명 | 호출 방식 |
|---------|------|----------|
| [clarify](./plugins/clarify) | 모호한 요구사항을 명확한 명세로 변환 | `/clarify` |
| [cp](./plugins/cp) | 커밋 & 푸시 한 번에 | `/cp` |
| [deploy](./plugins/deploy) | Railway, Cloudflare 통합 배포 | `/deploy` |
| [feature-dev](./plugins/feature-dev) | 7단계 체계적 기능 개발 워크플로우 | `/feature-dev` |
| [frontend-design](./plugins/frontend-design) | 고품질 프론트엔드 인터페이스 생성 | `/frontend-design` (자동) |
| [git](./plugins/git) | Git 커밋, 푸시, PR 자동화 | `/git:push`, `/git:push-pr` |
| [interview-prompt-builder](./plugins/interview-prompt-builder) | 요구사항 수집용 인터뷰 프롬프트 생성 | `/interview-prompt-builder` (자동) |
| [linear](./plugins/linear) | Linear 이슈 트래킹 통합 (MCP) | - |
| [perf](./plugins/perf) | 성능 측정 (Lighthouse/Core Web Vitals) | `/perf` |
| [simplify](./plugins/simplify) | 코드 단순화 및 정제 | `/simplify` |
| [sync](./plugins/sync) | 원격 저장소 동기화 (git pull) | `/sync` |
| [typescript-lsp](./plugins/typescript-lsp) | TypeScript/JS 언어 서버 (MCP) | - |
| [web-perf-ux](./plugins/web-perf-ux) | 웹 성능 및 UX 최적화 분석 | `/web-perf-ux` (자동) |
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

### cp

커밋과 푸시를 한 번에 수행합니다.

```
/cp                        # 자동 커밋 메시지 생성
/cp "fix: 버그 수정"        # 메시지 지정
```

- Conventional Commits 형식
- 민감한 파일 자동 감지 (`.env` 등)
- Co-Authored-By 자동 추가

---

### deploy

Railway, Cloudflare Pages/Workers 통합 배포.

```
/deploy              # 전체 배포
/deploy railway      # Railway만
/deploy cf           # Cloudflare Workers만
```

- 사전 체크: 커밋되지 않은 변경사항 확인
- 배포 후 상태 리포트

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

### perf

빠른 성능 측정. Lighthouse/Core Web Vitals 기반.

```
/perf                # 메인 페이지 측정
/perf /about         # 특정 경로
/perf --all          # 주요 페이지 일괄 측정
```

- LCP, CLS, INP 핵심 지표
- `web-perf-ux`의 간소화 버전

---

### simplify

코드 단순화. 기능은 유지하고 구현만 개선.

```
/simplify                 # 최근 수정 코드
/simplify src/utils.ts    # 특정 파일
```

원칙: 명확성 > 간결성, 중첩 삼항 금지, Opus 모델

---

### sync

원격 저장소 동기화 (git pull) 단축 명령어.

```
/sync              # origin main에서 pull
/sync develop      # 특정 브랜치
```

- 작업 중인 변경사항 있으면 경고
- 충돌 발생 시 해결 도움

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
| `/cp [msg]` | 커밋 & 푸시 |
| `/deploy [target]` | 통합 배포 |
| `/feature-dev <기능>` | 7단계 기능 개발 |
| `/frontend-design` | 프론트엔드 UI 생성 |
| `/git:push [msg] [--branch]` | 커밋 및 푸시 |
| `/git:push-pr [msg] [--base]` | 커밋, 푸시, PR |
| `/interview-prompt-builder` | 인터뷰 프롬프트 생성 |
| `/perf [path]` | 성능 측정 |
| `/simplify [file]` | 코드 단순화 |
| `/sync [branch]` | 원격 동기화 |
| `/web-perf-ux` | 웹 성능 분석 |
| `/wrap [msg]` | 세션 마무리 |

### 설치 명령어

```bash
claude plugin install clarify@october-plugins
claude plugin install cp@october-plugins
claude plugin install deploy@october-plugins
claude plugin install feature-dev@october-plugins
claude plugin install frontend-design@october-plugins
claude plugin install git@october-plugins
claude plugin install interview-prompt-builder@october-plugins
claude plugin install linear@october-plugins
claude plugin install perf@october-plugins
claude plugin install simplify@october-plugins
claude plugin install sync@october-plugins
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
│   │   └── skills/clarify/SKILL.md
│   ├── cp/
│   │   ├── .claude-plugin/plugin.json
│   │   └── skills/cp/SKILL.md
│   ├── deploy/
│   │   ├── .claude-plugin/plugin.json
│   │   └── skills/deploy/SKILL.md
│   ├── feature-dev/
│   │   ├── .claude-plugin/plugin.json
│   │   ├── agents/{code-explorer,code-architect,code-reviewer}.md
│   │   └── skills/feature-dev/SKILL.md
│   ├── frontend-design/
│   │   ├── .claude-plugin/plugin.json
│   │   └── skills/frontend-design/SKILL.md
│   ├── git/
│   │   ├── .claude-plugin/plugin.json
│   │   └── skills/{push,push-pr}/SKILL.md
│   ├── interview-prompt-builder/
│   │   ├── .claude-plugin/plugin.json
│   │   └── skills/interview-prompt-builder/SKILL.md
│   ├── linear/
│   │   ├── .claude-plugin/plugin.json
│   │   └── .mcp.json
│   ├── perf/
│   │   ├── .claude-plugin/plugin.json
│   │   └── skills/perf/SKILL.md
│   ├── simplify/
│   │   ├── .claude-plugin/plugin.json
│   │   ├── agents/{complexity-analyzer,pattern-checker,readability-analyzer,naming-reviewer,issue-simplifier}.md
│   │   └── skills/simplify/SKILL.md
│   ├── sync/
│   │   ├── .claude-plugin/plugin.json
│   │   └── skills/sync/SKILL.md
│   ├── typescript-lsp/
│   │   └── .claude-plugin/plugin.json
│   ├── web-perf-ux/
│   │   ├── .claude-plugin/plugin.json
│   │   └── skills/web-perf-ux/SKILL.md
│   └── wrap/
│       ├── .claude-plugin/plugin.json
│       ├── agents/{doc-updater,automation-scout,learning-extractor,followup-suggester,duplicate-checker}.md
│       └── skills/wrap/SKILL.md
└── README.md
```

## 라이선스

MIT
