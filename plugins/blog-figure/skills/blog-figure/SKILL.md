---
name: blog-figure
description: >
  Generate a static PNG figure for a blog post using Neo-Brutalism style (30 patterns:
  flow, comparison, architecture, data viz, charts, infographic, concept diagram, etc.).
  Invoke when: user wants any visual — figure, image, diagram, chart, graph, infographic,
  illustration, 시각화, 개념도, 도표, 그래프, 차트, 인포그래픽, 도식, 그림 — and context
  is a blog post or MDX file. Also invoke when an MDX file references a missing image in
  /blog/images/, or when user says "이 섹션에 이미지", "한 장으로 보여줘", "블로그 그림",
  "figure 만들어", "블로그 이미지", "다이어그램". NOT for interactive UI components, web pages,
  or app screens.
user-invocable: true
---

# Blog Figure Generator

Generate Neo-Brutalism styled figure images for blog posts: HTML → browser → PNG.

이 스킬의 디자인 토큰(1440×810 캡처, retina 2x, Noto Sans KR weight 900, agentic30 사이트
토큰)은 블로그 전용이며, PPT 지향의 구세대 neo-brutalism 문서(1920×1080, Black Han Sans,
`image-design-system.md`)와는 다른 세대다 — 그 문서를 이 스킬 수정의 참고 자료로 쓰지 마라.

## Workflow

1. **Understand context**: Read blog MDX/MD or user description to decide what to visualize
2. **Content Brief**: Extract the core concept to visualize and present to user for confirmation (see [Content Brief](#content-brief) below)
3. **Suggest patterns**: Based on the confirmed brief, pick the **4 most fitting patterns** from 30 available, and present them via `AskUserQuestion` with ASCII art previews (see [Pattern Selection](#pattern-selection) below)
4. **Create HTML**: Before writing HTML, read `references/design-rules.md` for all design constraints. Write standalone HTML to `/tmp/blog-figure-{name}.html` linking `assets/figure.css`
5. **Self-check before capture**: Run `scripts/validate_figure.py` on the HTML and fix every ERROR before spending a capture (see [Self-Check](#self-check) below). A browser screenshot won't tell you a font dropped to 14px or a color is hardcoded — the linter does, in a second, for free.
6. **Capture PNG**: Open in browser, screenshot at 1440×810, save PNG
7. **Save to project**: Move PNG to `blog/public/blog/images/{slug}/` (repo root인 `agentic30-greenfield` 기준 상대 경로). 실행 중인 리포에 이 디렉터리가 없으면 임의로 추측하지 말고 사용자에게 저장 위치를 물어라
8. **Insert into document**: If user provided a `.md` or `.mdx` file, insert the image tag at the contextually correct location (see [Document Insertion](#document-insertion) below)
9. **Verify**: Read the saved PNG and judge it at a glance — picture it shrunk to 25% on a phone. Can you still recognize the pattern structure and the key keywords? If text is cramped or the pattern reads wrong, fix the HTML and re-run from step 5. Don't ship a figure you couldn't parse on a phone.

## Content Brief

패턴을 고르기 **전에**, 블로그에서 시각화할 핵심 개념을 추출하여 사용자에게 확인받는다. Figure의 내용이 블로그와 동떨어지거나 너무 추상적이 되는 것을 방지하는 핵심 단계.

### 추출 항목

| 항목 | 설명 | 예시 |
|------|------|------|
| **핵심 메시지** | 이 Figure가 전달해야 할 한 문장 | "사용자가 말하는 것과 실제 행동은 다르다" |
| **키워드** | Figure에 실제로 들어갈 단어 3~5개 | "좋은데요", "0건", "말 vs 행동" |
| **구조** | 개념 간 관계 유형 | 대비(A vs B), 순서(A→B→C), 계층(A⊃B), 순환(A↻B) |
| **강조점** | 보는 사람이 가장 먼저 인식해야 할 것 | "0건이라는 숫자의 충격" |

### 추출 방법

블로그 글에서 다음을 찾는다:

1. **글의 핵심 주장/결론** — 제목, 서론 마지막 문장, 결론 첫 문장에서 발견됨
2. **구체적 사례/데이터** — 추상적 개념보다 구체적 숫자, 인용, 사례가 Figure에 적합
3. **대비/전환 구조** — "하지만", "반면", "이전에는 ~했지만 지금은", "X가 아니라 Y" 같은 전환점
4. **독자의 Aha moment** — 글을 읽다가 "오" 하고 멈칫할 지점. 그것이 Figure의 존재 이유

### 피해야 할 것

- 글의 목차를 그대로 나열 (Figure는 목차가 아님)
- 추상적 키워드만 나열 ("전략", "실행", "성과" → 어떤 글에나 끼워넣을 수 있으면 나쁜 Brief)
- 글 전체를 요약하려는 시도 (Figure는 글의 **한 장면**을 포착할 뿐)

### 사용자 확인

`AskUserQuestion`으로 2~3가지 시각화 방향을 제시한다. 각 옵션은 "이 글에서 무엇을 figure로 만들지"에 대한 서로 다른 해석이다.

```
AskUserQuestion({
  questions: [{
    question: "어떤 장면을 Figure로 만들까요?",
    header: "Content Brief",
    multiSelect: true,
    options: [
      {
        label: "해석 A: {1줄 핵심 메시지}",
        description: "키워드: {단어1}, {단어2}, {단어3}",
        markdown: "**구조**: {관계 유형}\n**강조점**: {가장 눈에 띄어야 할 것}\n**근거**: 블로그에서 이 부분이 Figure로 적합한 이유 1줄"
      },
      {
        label: "해석 B: {1줄 핵심 메시지}",
        description: "키워드: {단어1}, {단어2}, {단어3}",
        markdown: "**구조**: {관계 유형}\n**강조점**: {가장 눈에 띄어야 할 것}\n**근거**: 블로그에서 이 부분이 Figure로 적합한 이유 1줄"
      },
      {
        label: "해석 C: {1줄 핵심 메시지}",
        description: "키워드: {단어1}, {단어2}, {단어3}",
        markdown: "**구조**: {관계 유형}\n**강조점**: {가장 눈에 띄어야 할 것}\n**근거**: 블로그에서 이 부분이 Figure로 적합한 이유 1줄"
      }
    ]
  }]
})
```

**중요**: 각 해석은 글의 **서로 다른 부분/관점**을 포착해야 한다. 같은 내용을 다른 말로 바꾼 3개가 아니라, 진짜로 다른 장면 3개를 제시하라.

**`multiSelect: true`인 이유 — 장면 N개 = Figure N장**: 한 Figure에는 한 개의 핵심 개념만 담는다(One Idea Per Figure). 그래서 여러 장면을 한 장에 욱여넣는 대신, 사용자가 고른 장면 **하나하나에 대해 따로** 만든다.

- 1개 선택 → Figure 1장.
- 2개 이상 선택 → 고른 장면마다 Pattern Selection → HTML → Self-Check → Capture → 저장을 **장면별로 반복**한다. 파일명에 장면을 구분하는 접미사를 붙여 충돌을 막아라(`{slug}-{scene}.png`).
- 사용자가 아무것도 안 고르거나 "알아서"라고 하면, 가장 근거가 강한 장면 1개만 진행하고 그 이유를 한 줄로 알린다.

### Content Brief → Pattern Selection 연결

사용자가 Brief를 확인하면, 그 Brief의 **구조**가 패턴 선택을 자연스럽게 좁힌다:

| Brief 구조 | 적합한 패턴 (우선순위) |
|-----------|---------------------|
| 대비 (A vs B) | Comparison, Flow (split), Matrix, Network |
| 순서 (A→B→C) | Flow, Journey, Timeline, Storyboard |
| 계층 (A⊃B⊃C) | Architecture, Hierarchy, Isometric, Schema |
| 순환 (A↻B) | Loop, State, Graph |
| 개념 관계/벤다이어그램 | Concept, Network, Matrix |
| 수치 비교 | Data Viz, Funnel, Timeline, Waffle, Dumbbell, Bullet |
| 비율/구성비 | Waffle, Treemap, Funnel |
| 다차원 평가 | Radar, Matrix |
| 순위 변화 | Slope, Data Viz |
| 밀도/빈도 | Heatmap, Waffle |
| 실적/목표 | Bullet, Data Viz |
| 트렌드 요약 | Sparkline Grid, Data Viz |
| 증감 분해 | Waterfall, Data Viz |
| 인용/선언 | Typographic Statement |
| 상호작용 | Interaction, Terminal, IconDiagram, Storyboard |
| 추상/공간 구조 | Isometric, Network, Graph |
| 시스템 연결 | IconDiagram, Architecture, Interaction |

## Pattern Selection

After understanding context, use `AskUserQuestion` to let the user pick from the 4 most relevant patterns. Each option MUST include a `markdown` field with an ASCII art preview showing the pattern's layout structure.

### How to pick the 4 patterns

Analyze the user's content and rank all 30 patterns by relevance:
- **Comparison**: X vs Y, 좌우 대비, before/after
- **Flow**: 프로세스, 단계별 차이, 방법론
- **Timeline**: 시간 배분, 비율, 순서
- **Concept**: 관계도, 벤 다이어그램, 개념
- **Architecture**: 시스템 구성, 레이어, 컴포넌트
- **Interaction**: 시퀀스, 요청/응답, API 플로우
- **State**: 상태 전이, 라이프사이클
- **Schema**: DB 모델, 엔티티 관계
- **Hierarchy**: 트리, 조직도, 분류
- **Matrix**: 2x2 분석, 비교표
- **Journey**: 사용자 여정, 터치포인트
- **Funnel**: 전환율, 단계별 감소
- **Loop**: 순환 프로세스, 피드백
- **Data Viz**: 수치 비교, 바 차트
- **Storyboard**: 시나리오, 단계별 장면
- **Terminal**: CLI 시각화, 터미널 UI, 도구 사용 장면
- **Isometric**: 3D 블록, 와이어프레임, 레이어 구조 [SVG]
- **IconDiagram**: 시스템 다이어그램, 아이콘 연결, 기술 구성도 [SVG]
- **Network**: 노드 네트워크, 결정론↔확률 대비, 추상 관계 [Canvas]
- **Graph**: 포스-다이렉티드 그래프, 노드-링크 자동 레이아웃 [D3]
- **Waffle**: 비율 체감, 퍼센트 시각화, 100칸 중 N칸 [SVG]
- **Typographic Statement**: 에디토리얼 인용, 핵심 정의, 선언적 메시지 [SVG]
- **Slope**: 전후 순위 변화, 랭킹 이동, 두 시점 비교 [SVG]
- **Treemap**: 면적 비례 구성비, 카테고리 분포 [D3]
- **Radar**: 다축 프로파일 비교, 역량 평가, 다차원 지표 [SVG+JS]
- **Dumbbell**: 두 값 사이 갭/범위, 격차 비교 [SVG]
- **Heatmap**: 2D 빈도/밀도, 시간별·카테고리별 분포 [Canvas]
- **Bullet**: 실적 vs 목표, KPI 달성률 [SVG]
- **Sparkline Grid**: 다수 항목 트렌드 요약, 소형 라인차트 그리드 [SVG+JS]
- **Waterfall**: 증감 분해, 누적 변화, 요인별 기여도 [SVG]

Top 4를 선택하여 아래처럼 AskUserQuestion 호출:

```
AskUserQuestion({
  questions: [{
    question: "어떤 Figure 패턴이 가장 적합할까요?",
    header: "패턴 선택",
    multiSelect: false,
    options: [
      {
        label: "{Pattern 1 이름}",
        description: "{왜 이 패턴이 적합한지 1줄 설명}",
        markdown: "{ASCII art preview}"
      },
      // ... 3개 더
    ]
  }]
})
```

### ASCII Art Previews

4개 패턴을 결정한 뒤 `AskUserQuestion` 호출 **전에**
`references/pattern-previews.md`를 읽고 해당 패턴의 ASCII art를 가져와라.

### Example: AskUserQuestion Call

User가 "사용자 인터뷰 프로세스를 시각화해줘"라고 요청한 경우:

```
AskUserQuestion({
  questions: [{
    question: "어떤 Figure 패턴이 가장 적합할까요?",
    header: "패턴 선택",
    multiSelect: false,
    options: [
      {
        label: "Flow (추천)",
        description: "인터뷰 단계를 수직 플로우로 표현. 프로세스 시각화에 최적",
        markdown: "┌──────────────────────────────────┐\n│        ┌──────────────┐          │\n│        │  맥락 확인    │          │\n│        └──────┬───────┘          │\n│               ▼                  │\n│        ┌──────────────┐          │\n│        │  사례 복기    │          │\n│        └──────┬───────┘          │\n│               ▼                  │\n│        ┌──────────────┐          │\n│        │  니즈 발견    │          │\n│        └──────────────┘          │\n└──────────────────────────────────┘"
      },
      {
        label: "Journey",
        description: "인터뷰이의 여정을 수평 터치포인트로 표현",
        markdown: "┌──────────────────────────────────┐\n│  ①─────────②─────────③────────④  │\n│  준비     라포     질문     정리  │\n└──────────────────────────────────┘"
      },
      {
        label: "Timeline",
        description: "인터뷰 시간 배분을 비율로 시각화",
        markdown: "┌──────────────────────────────────┐\n│ ┌────────┬──────────┬────────┐   │\n│ │  라포   │   질문    │  정리  │   │\n│ │  3min  │   5min   │  2min  │   │\n│ └────────┴──────────┴────────┘   │\n└──────────────────────────────────┘"
      },
      {
        label: "Comparison",
        description: "좋은 인터뷰 vs 나쁜 인터뷰를 좌우 대비",
        markdown: "┌──────────────────────────────────┐\n│  ┌──────────┐  ┌──────────┐     │\n│  │ 나쁜방법  │VS│ 좋은방법  │     │\n│  │ ┌──────┐ │  │ ┌──────┐ │     │\n│  │ │평가요청│ │  │ │맥락확인│ │     │\n│  │ └──────┘ │  │ └──────┘ │     │\n│  └──────────┘  └──────────┘     │\n└──────────────────────────────────┘"
      }
    ]
  }]
})
```

**중요**: `markdown` 필드에는 해당 컨텍스트에 맞는 실제 키워드를 넣어라. 제네릭 플레이스홀더(Step 1, Card 1)가 아닌 실제 내용을 반영한 프리뷰를 보여줘야 사용자가 판단할 수 있다.

## Document Insertion

사용자가 `.md` 또는 `.mdx` 파일을 제공한 경우, PNG 저장 후 해당 파일에 이미지를 삽입한다.

### 삽입 규칙

1. **위치 결정**: Figure가 설명하는 컨텐츠의 **직후**에 삽입. 해당 섹션의 마지막 문단 뒤, 다음 `##` 헤딩 전
2. **MDX 파일** (`.mdx`):
   ```mdx
   <Figure src="/blog/images/{slug}/{filename}.png" alt="설명" caption="캡션" />
   ```
3. **Markdown 파일** (`.md`):
   ```markdown
   ![설명](/blog/images/{slug}/{filename}.png)
   ```
4. **빈 줄**: 삽입된 태그 앞뒤로 빈 줄 1개씩 확보
5. **복수 Figure**: 같은 파일에 여러 Figure를 삽입할 경우, 각각 관련 섹션 근처에 배치

### 삽입 위치 판단 기준

- Figure 내용과 가장 관련 높은 **헤딩(##, ###)** 을 찾는다
- 해당 헤딩의 본문 마지막 문단 뒤에 삽입
- 코드 블록(```) 내부에는 절대 삽입하지 않는다
- frontmatter(`---`) 내부에는 삽입하지 않는다
- 이미 동일 파일명의 Figure/image가 있으면 교체(중복 방지)
- **덮어쓰기 가드**: 저장 경로에 동일 파일명이 이미 존재하면, 먼저
  `sips -g pixelWidth -g pixelHeight <path>`로 기존 파일 해상도를 확인하라. 2880×1620이
  아니면 blog-figure 산출물이 아닐 수 있다(스크린샷·OG 카드가 같은 디렉터리에 섞여 있던
  사례가 있었다) — 덮어쓰기 전에 사용자 확인을 받아라

## HTML Template

```html
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=1440">
  <link rel="stylesheet" href="file://{SKILL_DIR}/assets/figure.css">
</head>
<body>
  <!-- figure content here -->
</body>
</html>
```

Replace `{SKILL_DIR}` with the **absolute path to this skill's directory** (the directory containing this SKILL.md). Resolve via the file path of this skill file, e.g. if SKILL.md is at `/path/to/skills/blog-figure/SKILL.md`, then `{SKILL_DIR}` = `/path/to/skills/blog-figure`.

## Self-Check

캡처는 비싸다(브라우저 구동 + 스크린샷 + retina 처리). HTML을 정적 린터로 한 번 거르면, "모바일에서 안 읽히는 figure를 캡처한 뒤에야" 깨닫는 낭비를 막는다. 디자인 룰 중 **기계로 딱 떨어지게 점검 가능한 것**만 검사한다.

```bash
python3 {SKILL_DIR}/scripts/validate_figure.py /tmp/blog-figure-{name}.html --pattern {PatternName}
```

- **ERROR가 하나라도 남아 있으면 캡처하지 마라.** HTML을 고치고 다시 돌려, 깨끗해진 뒤에 캡처한다. (이미 캡처한 뒤 ERROR를 발견했다면 HTML 수정 → 재캡처.)
- 점검 항목:
  - `small-font` (ERROR) — 20px(1.25rem) 미만 폰트. 25% 축소 시 사라진다. SVG `font-size`, CSS `px`/`rem` 모두 검사.
  - `hex-color` (ERROR) — 레이아웃에 하드코딩된 hex. `figure.css`의 `var(--*)`를 써라. **SVG/Canvas/D3 그래픽 내부의 hex는 정상이므로 잡지 않는다.**
  - `gradient` / `blur-shadow` (ERROR) — Neo-Brutalism은 평면 단색 + blur 0 그림자만. `linear-gradient`, `box-shadow`의 3번째 값(blur)≠0, `filter:blur`, `createLinearGradient` 등.
  - `word-count` / `component-cap` (WARNING) — 텍스트·컴포넌트 과다. 차단은 아니지만 거의 항상 줄이는 게 낫다.
- `--pattern Terminal`을 주면 단어 한도가 20→35로 올라간다(Terminal만 예외). 다른 패턴은 `--pattern` 생략 가능.
- 린터는 **렌더링하지 않는다.** 룰 위반만 잡는다 — "구조가 맞나·예쁜가·키워드가 한눈에 잡히나"는 9단계 육안 검수의 몫이다. 둘은 상호 보완이지 대체가 아니다.

## Capture (pick whichever is available)

**캡처 전 폰트 로드 확인 (필수)**: 캡처하기 전에 `document.fonts.ready`가 resolve되었는지,
그리고 Noto Sans KR이 실제로 적용됐는지 확인하라(예: `document.fonts.check('900 24px "Noto Sans KR"')`).
Google Fonts CDN 로드가 실패하면(오프라인 등) 시스템 fallback 폰트로 그대로 캡처하지 말고,
네트워크 상태를 점검한 뒤 재시도하라. `validate_figure.py`는 정적 린트일 뿐이라 폰트 렌더링
깨짐은 잡지 못한다 — 이건 육안 확인의 몫이다.

**30개 패턴 전체 검수용 gallery**:
```bash
python3 {SKILL_DIR}/scripts/render_pattern_previews.py --clean --output-dir /tmp/blog-figure-previews
```
검수용 gallery는 `file:///tmp/blog-figure-previews/index.html` 이다. Playwright MCP/CLI는 `file://`를 차단할 수 있으니 필요하면 `python3 -m http.server 8123 --directory /private/tmp` 후 `http://127.0.0.1:8123/blog-figure-previews/index.html`로 연다. 상세 검수는 `?density=detail` 쿼리를 붙여 2열 확대 모드로 본다. 상단 ready counter가 `30 / 30 ready`가 된 뒤 캡처하라.

**Chrome DevTools MCP** (preferred when Chrome is open):
1. `mcp__chrome-devtools__emulate` → viewport `{width:1440, height:810, deviceScaleFactor:2}` (retina 2880×1620)
2. `mcp__chrome-devtools__navigate_page` → `file:///tmp/blog-figure-{name}.html`
3. `mcp__chrome-devtools__take_screenshot` → `filePath: {target}.png`
4. After capture: `mcp__chrome-devtools__emulate` → viewport `null` (reset)

**Playwright MCP**:
1. `mcp__playwright__browser_resize` → 1440×810
2. `mcp__playwright__browser_navigate` → `file:///tmp/blog-figure-{name}.html`
3. `mcp__playwright__browser_take_screenshot` → `filename: {target}.png`

**Playwright CLI**:
```bash
npx playwright screenshot --viewport-size="1440,810" file:///tmp/blog-figure-{name}.html {target}.png
npx playwright screenshot --viewport-size="1600,4200" --wait-for-selector="body[data-gallery-ready='1']" --wait-for-timeout=3000 "http://127.0.0.1:8123/blog-figure-previews/index.html?density=detail" /tmp/blog-figure-previews/gallery-playwright.png
```

**Chrome CLI**:
```bash
google-chrome --headless --disable-gpu --hide-scrollbars --virtual-time-budget=5000 --window-size=1600,4200 --screenshot=/tmp/blog-figure-previews/gallery-chrome.png "file:///tmp/blog-figure-previews/index.html?density=detail"
```

**캡처 실패 시 복구**:
1. Chrome DevTools 연결 실패 → Playwright MCP 시도 → Fallback CLI 시도
2. 빈 PNG / 흰 화면 → HTML 파일을 `Read`로 확인 후 `file://` 경로가 올바른지 점검. `{SKILL_DIR}` 경로가 실제 figure.css 위치와 일치하는지 확인
3. 폰트 깨짐 → Canvas/D3 패턴에서 `document.fonts.ready.then()` 래핑 누락 여부 확인
4. 모든 방법 실패 → HTML 파일 경로를 사용자에게 알려주고 수동 캡처 요청

## Patterns

| Pattern | Use case | Key classes |
|---------|----------|-------------|
| **Comparison** | X vs Y, 좌우 대비 | `.split`, `.vs-badge` |
| **Flow** | 단계별 프로세스 | `.flow-card`, `.arrow-down`, `.icon` |
| **Timeline** | 시간 배분, 비율 | `.timeline`, `.tl-block` |
| **Concept** | 관계도, 개념 비교 | `.concept-block` |
| **Architecture** | 시스템 구성도, 레이어 | `.arch`, `.arch-layer`, `.arch-node` |
| **Interaction** | 시퀀스, 요청/응답 | `.seq`, `.seq-msg` |
| **State** | 상태 전이, 라이프사이클 | `.state-chain`, `.state-node` |
| **Schema** | DB 모델, 엔티티 관계 | `.schema-table`, `.schema-field` |
| **Hierarchy** | 트리, 조직도 | `.tree`, `.tree-node`, `.tree-level` |
| **Matrix** | 2x2 분석, 비교표 | `.matrix`, `.matrix-cell` |
| **Journey** | 사용자 여정, 터치포인트 | `.journey`, `.journey-step` |
| **Funnel** | 전환율, 단계별 감소 | `.funnel`, `.funnel-stage` |
| **Loop** | 순환 프로세스, 피드백 | `.loop`, `.loop-node` |
| **Data Viz** | 수치 비교, 바 차트 | `.bar-chart`, `.bar-row` |
| **Storyboard** | 시나리오, 단계별 장면 | `.storyboard`, `.story-panel` |
| **Terminal** | CLI 시각화, 터미널 UI | `.terminal`, `.terminal-card`, `.terminal-option` |
| **Isometric** | 3D 블록, 레이어, 와이어프레임 | SVG `<polygon>`, `.iso` |
| **IconDiagram** | 기술 다이어그램, 아이콘 연결 | SVG `<rect>`, `<marker>` |
| **Network** | 노드 네트워크, 추상 관계 | `<canvas>`, JS render |
| **Graph** | 포스-다이렉티드 그래프 | D3.js, `<svg>` |
| **Waffle** | 비율 체감, 퍼센트 | SVG `<rect>` 10x10 grid |
| **Typographic Statement** | 에디토리얼 인용, 핵심 정의 | SVG `<text>`, quote card |
| **Slope** | 전후 순위 변화, 랭킹 이동 | SVG `<line>`, `<circle>` |
| **Treemap** | 면적 비례 구성비 | D3.js treemap |
| **Radar** | 다축 프로파일 비교 | SVG + JS (cos/sin) |
| **Dumbbell** | 두 값 사이 갭/범위 | SVG `<circle>` x2 + `<line>` |
| **Heatmap** | 2D 빈도/밀도 분포 | `<canvas>`, JS lerp |
| **Bullet** | 실적 vs 목표, KPI | SVG nested `<rect>` + `<line>` |
| **Sparkline Grid** | 다수 항목 트렌드 요약 | SVG + JS, `<polyline>`, `<polygon>` |
| **Waterfall** | 증감 분해, 누적 변화 | SVG floating `<rect>` + connector |

Full HTML examples by category — **선택한 패턴이 속한 파일만 읽어라**:

| Category | File | Patterns |
|----------|------|----------|
| Layout | [references/patterns-layout.md](references/patterns-layout.md) | Comparison, Flow, Timeline, Concept, Architecture, Interaction, State, Schema, Hierarchy, Matrix, Journey, Funnel, Loop, Storyboard, Terminal (15) |
| Data Viz (static) | [references/patterns-dataviz-static.md](references/patterns-dataviz-static.md) | Data Viz, Waffle, Slope, Dumbbell, Bullet, Waterfall (6) |
| Data Viz (dynamic) | [references/patterns-dataviz-dynamic.md](references/patterns-dataviz-dynamic.md) | Treemap, Radar, Heatmap, Sparkline Grid (4) |
| Visual | [references/patterns-visual.md](references/patterns-visual.md) | Isometric, IconDiagram, Network, Graph, Typographic Statement (5) |

## Design Rules

Full design constraints are in [references/design-rules.md](references/design-rules.md). Read it before writing HTML.

### 모바일 가독성 — 최우선 원칙

> 이 PNG는 모바일에서 원본의 **25% 크기**로 보인다.
> 손톱만한 크기에서도 **패턴 구조와 핵심 키워드**가 인식되어야 한다.

- 읽을 수 없는 텍스트는 넣지 마라 — 어차피 안 보인다
- **색상 대비와 면적**으로 구조를 전달하라
- 텍스트는 "읽는 것"이 아니라 **"인식하는 것"**이어야 한다
- 한 Figure에 한 개의 핵심 개념만 담아라 (One Idea Per Figure)

### 컴포넌트 수량 제한 — 시원시원한 배치

**적은 수의 큰 컴포넌트 > 많은 수의 작은 컴포넌트**

| 패턴 | 최대 수량 | 이유 |
|------|---------|------|
| Flow | **3단계** | 3개면 비교 충분, 5개면 텍스트 덩어리 |
| Timeline | **3블록** | 블록 크기↑, 라벨 가독성↑ |
| Storyboard | **4패널 (2×2)** | 패널 크기 2배 확보 |
| Bar chart | **4행** | 바 높이 충분히 확보 |
| Architecture | **3레이어, 레이어당 3노드** (2노드면 너무 빈약) | 시스템 구조의 풍부함 |
| Split 비교 | **양쪽 각 2~3카드** | 카드 크기 유지 |
| Journey | **4단계** | dot 간 여백 확보 |
| Schema | **3테이블, 테이블당 3~4필드** | 글자 크기 유지 |
| Terminal | **3카드, 카드당 옵션 2개 (max 3)** | 질문 max 12자 1줄, `<br>` 금지 |
| Matrix | **2×2. 코너 4자 이내 또는 빈칸** | 축 라벨이 의미 전달 |
| Waffle | **1 grid (10x10), 2 카테고리** | 총 ~8단어 (범례 포함) |
| Typographic | **1 primary text (max 8단어)** | attribution max 4단어 |
| Slope | **max 5항목, 2시점** | 항목명 1단어 |
| Treemap | **max 6~8 cells** | 라벨 1단어, 80px 미만 숨김 |
| Radar | **max 5축, 1~2 series** | 축 라벨 1단어 |
| Dumbbell | **max 5 rows** | 라벨 max 3단어 |
| Heatmap | **max 7x5 grid (35 cells)** | 셀 ~110x90px |
| Bullet | **max 3~4 charts** | 범위 3단계 + 타겟 마커 |
| Sparkline Grid | **max 6 sparklines (3x2)** | 항목당 라벨 1단어 + 값 1개 |
| Waterfall | **max 6~8 bars** | 라벨 1~2단어, 시작/합계 포함 |
