# Agent Plugins

Claude Code와 Codex에서 함께 쓰는 경량 플러그인 저장소다. 현재 이 저장소는 아래 다섯 플러그인만 유지한다.

- [clarify](./plugins/clarify)
- [cp](./plugins/cp)
- [blog-figure](./plugins/blog-figure)
- [blog-humanize-fast](./plugins/blog-humanize-fast)
- [trend-scout](./plugins/trend-scout)

## 설치

### Skills 방식

이 저장소에는 요청한 플러그인만 남아 있으므로 `--skill '*'`로 설치해도 대상 스킬만 들어간다.

```bash
npx skills add october-academy/agent-plugins -a claude-code -a codex --skill '*' -y
```

### Claude Plugin Marketplace 방식

```bash
claude plugin marketplace add october-academy/agent-plugins
claude plugin marketplace update
claude plugin install <plugin-name>@agent-plugins
```

### Codex Plugin 방식

Codex CLI(0.144+)는 이 저장소의 `.claude-plugin/marketplace.json`을 그대로 읽으므로 별도 변환 없이 설치된다.

```bash
codex plugin marketplace add october-academy/agent-plugins   # 로컬 개발 중이면 체크아웃 경로를 대신 지정
codex plugin add <plugin-name>@agent-plugins
```

- Codex에서 스킬은 `clarify:interview`처럼 `플러그인:스킬` 이름으로 등록된다. 슬래시 커맨드 대신 프롬프트에서 스킬 이름을 지목해 호출한다.
- 설치본은 `~/.codex/plugins/cache/agent-plugins/<plugin>/<version>`에 버전 키로 스냅샷된다. 플러그인 내용을 고친 뒤에는 버전을 올리거나, 같은 버전이면 `codex plugin remove <plugin>` 후 `codex plugin add`로 재설치해야 반영된다.

## 현재 플러그인

| 플러그인 | 역할 | 호출 방식 |
| --- | --- | --- |
| [clarify](./plugins/clarify) | 모호한 요구사항, 전략 맹점, content-vs-form 판단을 세 가지 렌즈로 정리 | `/clarify:interview`, `/clarify:unknown`, `/clarify:metamedium` |
| [cp](./plugins/cp) | 변경사항을 스테이징, 커밋, 푸시까지 한 번에 처리 | `/cp` |
| [blog-figure](./plugins/blog-figure) | 블로그용 정적 figure 이미지를 HTML→브라우저 캡처→PNG 파이프라인으로 생성 | `/blog-figure` |
| [blog-humanize-fast](./plugins/blog-humanize-fast) | 블로그 최종 원고를 청크 병렬 strict 워크플로로 보수 윤문 | `/blog-humanize-fast` |
| [trend-scout](./plugins/trend-scout) | Reddit, HN, GitHub, 한국 커뮤니티, RSS 등에서 Threads 소재를 수집/큐레이션 | `/trend-scout` |

## 런타임 호환성

| 플러그인 | Claude Code | Codex |
| --- | --- | --- |
| clarify | ✅ | ✅ Stop 훅 반복 루프까지 동일 동작 (`request_user_input` 폴백) |
| cp | ✅ | ✅ |
| blog-figure | ✅ | ✅ (`request_user_input` 폴백, 캡처는 Chrome CLI 경로 사용 가능) |
| blog-humanize-fast | ✅ | ❌ Claude Code 전용 — Workflow 도구 필요. Codex에선 `humanize-korean` Fast Path 권장 |
| trend-scout | ✅ | ✅ |

## 빠른 예시

```bash
/clarify:interview "로그인 기능 추가"
/clarify:unknown "Q2 성장 전략 점검"
/clarify:metamedium "콘텐츠는 많은데 성과가 정체됨"
/cp "docs: prune plugin marketplace"
/blog-figure
/blog-humanize-fast web/src/content/blog/example.mdx
/trend-scout
```

## 저장소 구조

```text
agent-plugins/
├── .claude-plugin/marketplace.json
├── plugins/
│   ├── blog-figure/
│   ├── blog-humanize-fast/
│   ├── clarify/
│   ├── cp/
│   └── trend-scout/
├── CLAUDE.md
├── PLUGIN_DEVELOPMENT.md
└── scripts/validate-plugins.sh
```

## 유지 원칙

- 루트 문서와 `.claude-plugin/marketplace.json`은 항상 동일한 플러그인 셋을 반영한다.
- 플러그인 버전은 각 `plugin.json`과 마켓플레이스 엔트리에서 일치해야 한다.
- 새 플러그인을 추가하거나 제거하면 `./scripts/validate-plugins.sh`로 바로 검증한다.
