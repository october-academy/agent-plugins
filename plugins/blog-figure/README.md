# Blog Figure

Neo-Brutalism style figure images (PNG) for blog posts. HTML → browser capture → PNG pipeline.

이 스킬의 디자인 토큰(1440×810 캡처, retina 2x, Noto Sans KR weight 900, agentic30 사이트
토큰)은 블로그 전용이며, PPT 지향의 구세대 neo-brutalism 문서(1920×1080, Black Han Sans,
`image-design-system.md`)와는 다른 세대다 — 그 문서를 이 스킬 수정의 참고 자료로 쓰지 마라.

## Installation

```bash
# 1. Add marketplace (first time only)
claude plugin marketplace add october-academy/agent-plugins

# 2. Update marketplace
claude plugin marketplace update

# 3. Install plugin
claude plugin install blog-figure@agent-plugins

# 4. Restart Claude Code
```

## Usage

```bash
/blog-figure                # Invoke directly
```

### Auto-triggers

- "figure 만들어", "블로그 이미지", "다이어그램", "시각화", "개념도", "도표", "그래프", "차트", "인포그래픽", "그림"
- "이 섹션에 이미지", "한 장으로 보여줘", "블로그 그림"
- MDX references a missing image in `/blog/images/`
- User wants to visualize a concept for a blog post

## How It Works

```
┌─────────────────────────────────────────┐
│  1. Read blog MDX / user description    │
└──────────────────┬──────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────┐
│  2. Confirm content brief               │
│     choose from 30 patterns             │
│     (layout, data-viz, visual)          │
└──────────────────┬──────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────┐
│  3. Create standalone HTML              │
│     /tmp/blog-figure-{name}.html        │
└──────────────────┬──────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────┐
│  4. Capture PNG (1440x810, retina 2x)   │
│     Chrome DevTools MCP / Chrome CLI (2x)│
│     / Playwright MCP·CLI (1x fallback)   │
└──────────────────┬──────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────┐
│  5. Save to project images directory    │
└─────────────────────────────────────────┘
```

## Pattern Families

| Family | Patterns | Use Case |
|--------|----------|----------|
| **Layout (15)** | Comparison, Flow, Timeline, Concept, Architecture, Interaction, State, Schema, Hierarchy, Matrix, Journey, Funnel, Loop, Storyboard, Terminal | Process, structure, contrast, narrative |
| **Data Viz Static (6)** | Data Viz, Waffle, Slope, Dumbbell, Bullet, Waterfall | Bar charts, ratios, ranking change, KPI |
| **Data Viz Dynamic (4)** | Treemap, Radar, Heatmap, Sparkline Grid | JS/D3/Canvas: composition, profiles, density, trends |
| **Visual (5)** | Isometric, IconDiagram, Network, Graph, Typographic Statement | Editorial figures, system diagrams, generative visuals |

## Validation

### Figure Self-Check (lint before capture)

Lints a generated figure's HTML against the machine-checkable design rules
(min font ≥ 20px, no hardcoded hex in layout, no gradients, no blur shadows,
word/component budgets) **before** spending a browser capture. SVG/Canvas/D3
graphics are exempt from the hex rule.

```bash
python3 plugins/blog-figure/skills/blog-figure/scripts/validate_figure.py /tmp/blog-figure-{name}.html --pattern Funnel
```

- Exit 0 = no ERRORs (WARNINGs allowed); non-zero = fix required.
- `--json` for machine-readable output; `--pattern Terminal` raises the word budget to 35.

### Pattern Gallery

```bash
python3 plugins/blog-figure/skills/blog-figure/scripts/render_pattern_previews.py --clean --output-dir /tmp/blog-figure-previews
python3 -m http.server 8123 --directory /private/tmp
```

- Gallery: `file:///tmp/blog-figure-previews/index.html`
- MCP-friendly URL: `http://127.0.0.1:8123/blog-figure-previews/index.html`
- Detail QA URL: `http://127.0.0.1:8123/blog-figure-previews/index.html?density=detail`
- Ready signal: 상단 counter가 `30 / 30 ready`

### Workspace Review Site (dev 전용)

```bash
python3 plugins/blog-figure/skills/blog-figure/scripts/build_workspace_review_site.py
```

- **dev 전용 도구**: 30개 eval 산출물이 담긴 `blog-figure-workspace`가 있을 때만 동작한다.
  이 workspace는 배포 플러그인에 포함되지 않으므로 일반 사용에는 필요 없다 — workspace가 없으면
  스크립트가 무엇이 없는지 안내하고 종료한다
- Review entry: `plugins/blog-figure/skills/blog-figure-workspace/review/index.html`
- 목적: `final-test` + `iteration-3`의 30개 eval 산출물을 HTTP-friendly review copy로 한 번에 검수
- MCP 검수 시에는 `plugins/blog-figure/skills/blog-figure-workspace/review/` 상위를 HTTP로 서빙해서 연다

### CLI Capture

```bash
npx playwright screenshot --viewport-size="1600,4200" --wait-for-selector="body[data-gallery-ready='1']" --wait-for-timeout=3000 "http://127.0.0.1:8123/blog-figure-previews/index.html?density=detail" /tmp/blog-figure-previews/gallery-playwright.png
'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome' --headless --disable-gpu --hide-scrollbars --virtual-time-budget=8000 --window-size=1600,4200 --screenshot=/tmp/blog-figure-previews/gallery-chrome.png "http://127.0.0.1:8123/blog-figure-previews/index.html?density=detail"
```

## Design Rules

- **Size**: 1440x810 (16:9)
- **Border**: 3px solid #0a0a0a
- **Shadow**: Npx Npx 0px #0a0a0a (no blur)
- **Fonts**: Noto Sans KR 900 (titles), Noto Sans KR 700 (body)
- **Colors**: CSS variables only
- **Graphics**: HTML 패턴은 emoji 가능, 시각 패턴은 inline SVG / Canvas / D3 사용

## Changelog

- **3.0.0** — **AGENTIC 디자인 시스템 v1.2 정렬 + Wilke 원칙 보강** (breaking: 산출물 팔레트가
  구세대 주황에서 v1.2 파랑으로 전면 교체 — 기존 블로그 figure와 색이 달라진다).
  ① **토큰 리매핑**(정본: `agentic30-greenfield/docs/design/agentic-ui-v1.2/tokens.css`):
  액센트 #FF6B35 → Blue500 `#0968F6`, good/bad 시맨틱 lime·핑크 폐기 → Green/Red의
  200(면)·600(강조면+white)·700(텍스트) 3단 배지 문법, `--highlight` → Yellow300 `#FFE58A`,
  `--muted-fg` → Neutral600 `#616161`, 카테고리 `--tl-*` 8 hue×500스텝(Teal 신설, lime·amber는
  alias). 600 강조면 위 텍스트는 white로 재배선(`.data-card`·`.quote-card`·`.icon.*`·
  `.state-node.*`·`.schema-fk`·`.mark-*`·matrix 헤더), tl-blue/purple 면 위도 white(dark 4.1/3.1
  미달). Terminal 다크 스코프는 스텝 승급(N500·Blue400·Green500·Purple400).
  ② **색 문법 3규칙 명문화**(design-rules "색 문법"): 배지 200+700(실측 7.9~16.8) / 강조면
  600+white(4.7~9.6) 조합만 허용, lime·yellow류 선·텍스트 금지(선 팔레트 7종 실측 3.6~5.9),
  **색은 인코딩 수단** — 단일 계열은 단색+강조 1색, good/bad 병치는 색에만 의존 금지
  (Green600 vs Red600 명도 1.09:1 — deuteranopia 시뮬로 검증, 아이콘·라벨 병행 필수).
  ③ **Wilke 보강**: Funnel 폭=값 정비례 강제+클램프 금지+바 밖 우측 라벨+단색, Treemap을
  위계 데이터(그룹=hue, 자식=명도 스텝)로 재작성+"flat 비율엔 바 차트" 명시, Data Viz 바
  단색(`--dark`)+강조 1색, Waffle·Radar·Dumbbell 범례 → 직접 라벨(edge-midpoint·첫 행
  endpoint), Journey dot 단일 계열+마지막 강조. ④ **타이포 컨셉 이식**: 48px+ 타이틀 음수
  트래킹(−0.01~−0.015em), 영문 마이크로 라벨용 `.micro-label`(JetBrains Mono uppercase).
  30패턴 재렌더·validate 전건 통과, deuteranopia/protanopia 스와치 검증 완료.
- **2.5.0** — 30패턴 갤러리 apple-design 평가에서 실측된 시스템 결함 해소(WCAG 대비율 기준).
  ① **유색 면 위 저대비 텍스트**: Hierarchy 부제의 `--muted-fg`(blue 위 1.29:1) → `--dark`,
  `.arch-label` 기본색 white → `--dark`(lime 위 1.5:1 방지), design-rules에 "유색 면 위
  muted-fg 금지 + accent 텍스트는 연한 배경 전용" 규칙 신설. ② **강조 역전 수정**: Comparison
  "0건"(`--bad-card` 위 `--bad-accent` 1.58:1) → 카드 최대 요소(3.5rem `--dark` 900), Journey %
  수치(muted 20px) → 카드 하단 앵커 3rem 900 — "핵심 수치는 가장 큰 시각 무게" 규칙 명문화.
  ③ **lime/yellow 선·글자색 금지**(bg 위 1.2~1.4:1, 채움면+black 전용): Slope·Sparkline 선을
  dark green #4d7c0f 등 선 팔레트(blue/orange/pink/purple/dark green)로 교체. ④ **커넥터 두께
  시스템**: figure.css 화살표 샤프트 3→6px + 화살촉 ≥20px(`.arrow-*`, `.journey-line`,
  `.tree-*line`, `.seq-msg-*`), IconDiagram stroke 6 + marker 24px(userSpaceOnUse), Waterfall
  connector 1.5→5px, Interaction 메시지 화살표 6px. Loop는 직선 4개 → **링 + 코너 화살촉**으로
  재설계(순환 시인성). Journey 카드 min-height 540px(캔버스 채움). ⑤ 자잘한 정합: Treemap
  잔여 항목 "기타" 병합(무라벨 색면 방지), Heatmap 범례 핫스팟 원형 → 셀과 같은 사각형,
  Data Viz Angular=pink 통일, Concept 중앙 블록 z-order 최상위, Network 최대 노드 라벨
  '0'→'1.0'.
- **2.4.0** — 품질 패스(감사 + 30패턴 시각 리뷰 + fresh-context 검증). ① SKILL.md의
  AskUserQuestion `markdown` 필드(현행 스키마에 없음) 8곳을 `preview`로 교정, Capture 절차를
  `references/capture.md`로 이관. ② `validate_figure.py`의 `<style>` 내 hex 미탐 수정,
  `build_workspace_review_site.py` workspace 부재 시 안내 종료. ③ 패턴 레퍼런스 시각 결함
  일괄 해소 — Waffle 100셀 완성 SVG(critical), Isometric 라벨 가림, Interaction 시퀀스 의미,
  Typographic 중앙정렬, Funnel 폭 규칙 문서화, 수직 여백 과다 계열 정상화. ④ evals.json
  보정 — Loop 노드 상한을 스킬 표준형(4+center)에 정합, Slope/Dumbbell 단어 예산 예외,
  MDX 삽입·PNG 캡처 assertion 추가.
- **2.3.0** — [html-effectiveness](https://thariqs.github.io/html-effectiveness/) 20개 데모
  벤치마킹 결과 반영. ① ASCII 프리뷰 전각(한글=2칸) 정렬 결함 수정 — SKILL.md 예제 4개와
  pattern-previews.md 템플릿 21개 교정, 전각 검산 규칙 명문화. ② 패턴 선택 시 요청하면
  기존 30패턴 갤러리를 실물 프리뷰로 여는 배선 추가(신규 코드 0줄). ③ Verify 단계를
  상상("25%로 줄었다고 상상하라")에서 관찰(`sips -Z 360` 축소본 생성 후 Read)로 교체.
  ④ PNG 옆에 `{filename}.src.html` 소스 보존 + HTML 템플릿 provenance 주석
  (blog/scene/pattern) + `validate_figure.py`에 provenance WARNING 규칙 — 다음 세션의
  부분 수정이 전체 재작성 대신 Edit 한 번 + 재캡처가 되는 세션 간 재수정 계약
- **2.2.0** — 블로그가 `agentic30-greenfield` 리포의 `blog/` (Astro SSG)로 이전됨에 따라
  저장 경로 계약을 `blog/public/blog/images/{slug}/`로 수정. 캡처 전 폰트 로드 검증 추가
  (`document.fonts.check()`는 CDN CSS 실패를 못 잡으므로 로드된 face status 단언 방식).
  동일 파일명 덮어쓰기 가드 추가(해상도 확인 — sips/identify/PIL, 2880×1620·1440×810 정상).
  캡처 경로 정비: Chrome CLI `--force-device-scale-factor=2` retina 캡처 추가, Playwright는
  1x 최후 수단으로 격하. Output Spec 섹션 신설(retina 2x 표준, 해상도 보존 압축
  pngquant/oxipng — `sips -Z` 리샘플 금지)

## License

MIT
