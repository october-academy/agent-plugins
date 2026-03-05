---
name: blog-figure
description: >
  Generate Neo-Brutalism style figure images (PNG) for blog posts. Creates standalone HTML,
  opens in Chrome DevTools / Playwright, captures screenshot, and saves PNG.
  Use when: (1) user asks to create a blog figure/image/diagram, (2) user says "figure 만들어",
  "블로그 이미지", "다이어그램 생성", (3) MDX references a missing image in /blog/images/,
  (4) user wants to visualize a concept for a blog post.
user-invocable: true
---

# Blog Figure Generator

Generate Neo-Brutalism styled figure images for blog posts: HTML → browser → PNG.

## Workflow

1. **Understand context**: Read blog MDX/MD or user description to decide what to visualize
2. **Content Brief**: Extract the core concept to visualize and present to user for confirmation (see [Content Brief](#content-brief) below)
3. **Suggest patterns**: Based on the confirmed brief, pick the **4 most fitting patterns** from 16 available, and present them via `AskUserQuestion` with ASCII art previews (see [Pattern Selection](#pattern-selection) below)
4. **Create HTML**: Write standalone HTML to `/tmp/blog-figure-{name}.html` linking `assets/figure.css`
5. **Capture PNG**: Open in browser, screenshot at 1440×810, save PNG
6. **Save to project**: Move PNG to `apps/content/src/content/blog/images/{slug}/`
7. **Insert into document**: If user provided a `.md` or `.mdx` file, insert the image tag at the contextually correct location (see [Document Insertion](#document-insertion) below)
8. **Verify**: Read the saved PNG to visually confirm

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

### Content Brief → Pattern Selection 연결

사용자가 Brief를 확인하면, 그 Brief의 **구조**가 패턴 선택을 자연스럽게 좁힌다:

| Brief 구조 | 적합한 패턴 (우선순위) |
|-----------|---------------------|
| 대비 (A vs B) | Comparison, Flow (split), Matrix |
| 순서 (A→B→C) | Flow, Journey, Timeline, Storyboard |
| 계층 (A⊃B⊃C) | Architecture, Hierarchy, Schema |
| 순환 (A↻B) | Loop, State |
| 수치 비교 | Data Viz, Funnel, Timeline |
| 상호작용 | Interaction, Terminal, Storyboard |

## Pattern Selection

After understanding context, use `AskUserQuestion` to let the user pick from the 4 most relevant patterns. Each option MUST include a `markdown` field with an ASCII art preview showing the pattern's layout structure.

### How to pick the 4 patterns

Analyze the user's content and rank all 15 patterns by relevance:
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

### ASCII Art Preview Templates

각 패턴의 markdown preview에 사용할 ASCII art 템플릿:

**Comparison**:
```
┌──────────────────────────────────┐
│  ┌──────────┐  ┌──────────┐     │
│  │  Left    │VS│  Right   │     │
│  │ ┌──────┐ │  │ ┌──────┐ │     │
│  │ │Card 1│ │  │ │Card 1│ │     │
│  │ └──────┘ │  │ └──────┘ │     │
│  │ ┌──────┐ │  │ ┌──────┐ │     │
│  │ │Card 2│ │  │ │Card 2│ │     │
│  │ └──────┘ │  │ └──────┘ │     │
│  └──────────┘  └──────────┘     │
└──────────────────────────────────┘
```

**Flow**:
```
┌──────────────────────────────────┐
│        ┌──────────────┐          │
│        │   Step 1     │          │
│        └──────┬───────┘          │
│               ▼                  │
│        ┌──────────────┐          │
│        │   Step 2     │          │
│        └──────┬───────┘          │
│               ▼                  │
│        ┌──────────────┐          │
│        │   Step 3     │          │
│        └──────────────┘          │
└──────────────────────────────────┘
```

**Timeline**:
```
┌──────────────────────────────────┐
│ ┌────────┬──────────┬────────┐   │
│ │ Block1 │  Block2  │ Block3 │   │
│ │  3min  │   5min   │  4min  │   │
│ └────────┴──────────┴────────┘   │
└──────────────────────────────────┘
```

**Concept**:
```
┌──────────────────────────────────┐
│    ┌───────┐                     │
│    │   A   │  ┌───────────┐      │
│    │       ├──┤     B     │      │
│    └───────┘  │           ├──┐   │
│               └───────────┘  │   │
│                    ┌─────────┤   │
│                    │    C    │   │
│                    └─────────┘   │
└──────────────────────────────────┘
```

**Architecture**:
```
┌──────────────────────────────────┐
│ Client  │ [Web] [Mobile] [CLI]   │
│─────────┼────────────────────────│
│ Service │ [API] [Auth] [Events]  │
│─────────┼────────────────────────│
│ Data    │ [PostgreSQL] [Redis]   │
└──────────────────────────────────┘
```

**Interaction**:
```
┌──────────────────────────────────┐
│  [User]              [Server]    │
│    │── Request ──────────▶│      │
│    │◀── Response ─ ─ ─ ──│      │
│    │── Action ───────────▶│      │
│    │◀── Result ─ ─ ─ ─ ──│      │
└──────────────────────────────────┘
```

**State**:
```
┌──────────────────────────────────┐
│ (Start)──▶[State A]──▶[State B] │
│                          │       │
│                          ▼       │
│                       [State C]  │
│                          │       │
│                          ▼       │
│                        (End)     │
└──────────────────────────────────┘
```

**Schema**:
```
┌──────────────────────────────────┐
│ ┌──────────┐  ┌──────────┐      │
│ │ User     │  │ Post     │      │
│ ├──────────┤  ├──────────┤      │
│ │ id    PK │  │ id    PK │      │
│ │ email    │──│ user  FK │      │
│ │ name     │  │ title    │      │
│ └──────────┘  └──────────┘      │
└──────────────────────────────────┘
```

**Hierarchy**:
```
┌──────────────────────────────────┐
│           [Root]                 │
│          ┌──┼──┐                 │
│          ▼  ▼  ▼                 │
│        [A] [B] [C]               │
│        ┌┼┐                       │
│        ▼ ▼                       │
│      [D][E]                      │
└──────────────────────────────────┘
```

**Matrix**:
```
┌──────────────────────────────────┐
│         │  High    │  Low       │
│─────────┼──────────┼────────────│
│  Easy   │ QuickWin │ Fill      │
│─────────┼──────────┼────────────│
│  Hard   │ Big Bet  │ Avoid     │
└──────────────────────────────────┘
```

**Journey**:
```
┌──────────────────────────────────┐
│  ①─────────②─────────③────────④  │
│  발견     가입      Aha!    재방문 │
└──────────────────────────────────┘
```

**Funnel**:
```
┌──────────────────────────────────┐
│ ┌────────────────────────────┐   │
│ │       Visit  10,000        │   │
│ ├──────────────────────┤         │
│ │    Signup  3,200     │         │
│ ├────────────────┤               │
│ │  Trial   720   │               │
│ ├──────────┤                     │
│ │ Pay  180 │                     │
└──────────────────────────────────┘
```

**Loop**:
```
┌──────────────────────────────────┐
│  [Plan]───▶[Do]                  │
│    ▲          │                   │
│    │    ↻     ▼                   │
│  [Act]◀───[Check]                │
└──────────────────────────────────┘
```

**Data Viz**:
```
┌──────────────────────────────────┐
│  React  ████████████████░░ 85%   │
│  Vue    ███████████████░░░ 78%   │
│  Svelte ██████████████████ 92%   │
│  Angular████████████░░░░░░ 54%   │
└──────────────────────────────────┘
```

**Storyboard**:
```
┌──────────────────────────────────┐
│  ┌─────────┐   ┌─────────┐      │
│  │①        │   │②        │      │
│  │ Scene 1 │   │ Scene 2 │      │
│  └─────────┘   └─────────┘      │
│  ┌─────────┐   ┌─────────┐      │
│  │③        │   │④        │      │
│  │ Scene 3 │   │ Scene 4 │      │
│  └─────────┘   └─────────┘      │
└──────────────────────────────────┘
```

**Terminal**:
```
┌──────────────────────────────────┐
│ ~ /project                      │
│ > command                       │
│ ● Tool output                   │
│ ┌─Step 1─┐ ┌─Step 2─┐ ┌─Step 3─┐│
│ │ ● opt  │ │ ○ opt  │ │ ● opt  ││
│ │ ○ opt  │ │ ● opt  │ │ ○ opt  ││
│ └────────┘ └────────┘ └────────┘│
│ ● Result                        │
└──────────────────────────────────┘
```

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

Replace `{SKILL_DIR}` with absolute path `~/.claude/skills/blog-figure`.

## Capture (pick whichever is available)

**Chrome DevTools MCP** (preferred when Chrome is open):
1. `mcp__chrome-devtools__emulate` → viewport `{width:1440, height:810, deviceScaleFactor:2}` (retina 2880×1620)
2. `mcp__chrome-devtools__navigate_page` → `file:///tmp/blog-figure-{name}.html`
3. `mcp__chrome-devtools__take_screenshot` → `filePath: {target}.png`
4. After capture: `mcp__chrome-devtools__emulate` → viewport `null` (reset)

**Playwright MCP**:
1. `mcp__playwright__browser_resize` → 1440×810
2. `mcp__playwright__browser_navigate` → `file:///tmp/blog-figure-{name}.html`
3. `mcp__playwright__browser_take_screenshot` → `filename: {target}.png`

**Fallback CLI**:
```bash
npx playwright screenshot --viewport-size="1440,810" file:///tmp/blog-figure-{name}.html {target}.png
```

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

Full HTML examples for each: [references/figure-patterns.md](references/figure-patterns.md)

## Design Rules

- **Size**: 1440×810 (16:9)
- **Border**: 3px solid #0a0a0a
- **Shadow**: Npx Npx 0px #0a0a0a (no blur ever)
- **Title font**: Noto Sans KR 900 (headings/labels only)
- **Body font**: Noto Sans KR, weight 700 (bold default). Use 400 only for minor annotations
- **Code/number font**: JetBrains Mono (`.mono`, `.code`, `.tag`)
- **Colors**: CSS variables only — never hardcode hex in HTML
- **No**: gradients, blur shadows, soft edges

### 모바일 가독성 — 최우선 원칙

> 이 PNG는 모바일에서 원본의 **25% 크기**로 보인다.
> 손톱만한 크기에서도 **패턴 구조와 핵심 키워드**가 인식되어야 한다.

- 읽을 수 없는 텍스트는 넣지 마라 — 어차피 안 보인다
- **색상 대비와 면적**으로 구조를 전달하라
- 텍스트는 "읽는 것"이 아니라 **"인식하는 것"**이어야 한다
- 한 Figure에 한 개의 핵심 개념만 담아라 (One Idea Per Figure)

### 텍스트 버짓 — 절대 한도

**Figure는 글의 설명을 대체하지 않는다. 시각적 앵커를 제공할 뿐이다.**

| 컴포넌트 | 최대 텍스트 | 예시 |
|---------|-----------|------|
| `.flow-card` | **제목 2~4단어**. 설명 생략 또는 max 6자 | "맥락 확인", "사례 복기" |
| `.quote-card` | **max 8자** (핵심 키워드만) | "좋은데요!", "0건" |
| `.section-label` | **max 6자** | "나쁜 예시", "좋은 방법" |
| `.tl-anno` | **사용 자제**. 쓸 경우 max 4자 키워드 | "맥락", "사례" |
| `.journey-desc` | **max 6자** | "서비스 인지" |
| `.story-desc` | **max 6자** | "결제 확인" |
| `.bar-label` | **max 4단어** | "React", "설문 응답률" |
| `.terminal-card-question` | **2줄 이내** (`<br>` 금지, balance 자동 줄바꿈) | "허수 포함 시 거짓 성공감 위험은?" |
| `.terminal-option` | **max 10자** | "WAU 기준 활성 유저만" |
| Figure 전체 | **max 20~25단어** | — |

### 최소 폰트 크기

1440px 캔버스에서 **1.25rem(20px) 미만 텍스트 금지**. 모바일 25% 축소 시 5px 미만은 읽기 불가.

| 역할 | 최소 크기 |
|------|---------|
| 가장 작은 텍스트 (`.tag`, `.schema-pk`) | 1rem (16px) |
| 설명/부연 (`.journey-desc`, `.story-desc`) | 1.25rem (20px) |
| 라벨/캡션 (`.flow-card`, `.bar-label`) | 1.5rem (24px) |
| 섹션 헤딩 (`.section-label`) | 2rem (32px) |
| Figure 제목 (`.figure-title`) | 3rem (48px) |

### 컴포넌트 수량 제한 — 시원시원한 배치

**적은 수의 큰 컴포넌트 > 많은 수의 작은 컴포넌트**

| 패턴 | 최대 수량 | 이유 |
|------|---------|------|
| Flow | **3단계** | 3개면 비교 충분, 5개면 텍스트 덩어리 |
| Timeline | **3블록** | 블록 크기↑, 라벨 가독성↑ |
| Storyboard | **4패널 (2×2)** | 패널 크기 2배 확보 |
| Bar chart | **4행** | 바 높이 충분히 확보 |
| Architecture | **3레이어, 레이어당 3노드** | 공간 여유 |
| Split 비교 | **양쪽 각 2~3카드** | 카드 크기 유지 |
| Journey | **4단계** | dot 간 여백 확보 |
| Schema | **3테이블, 테이블당 4필드** | 글자 크기 유지 |
| Terminal | **3카드, 카드당 옵션 2~4개** | 질문 2줄 이내, `<br>` 금지 |

### Weight Hierarchy

| Role | Weight | Example |
|------|--------|---------|
| 모든 텍스트 기본값 | 700 | body default, `.flow-card`, `.journey-desc` |
| 부연/보조 (드물게 사용) | 400 | 긴 설명이 불가피할 때만 |
| Display titles | Noto Sans KR 900 | `.figure-title`, `.section-label` |

### Composition — 정형화 피하기

- `.figure-title` + `.insight-box`를 **매번 넣지 마라**. 컨텐츠만으로 의미가 전달되면 생략
- 제목이 필요하면 `.figure-title` 대신 패턴 내부에 자연스럽게 포함
- 하단 요약이 필요하면 `.insight-box` 대신 `.callout`이나 `.mark`로 변주
- 같은 블로그 포스트 내 여러 Figure는 각각 다른 구성을 사용할 것

### 아이콘/이모지 원칙

- **텍스트만으로 충분하면 아이콘 생략**. `.icon` 원형은 선택 사항
- `.flow-card`는 아이콘 없이 `<strong>제목</strong>`만으로 충분. 설명 텍스트 최소화
- 이모지는 카테고리 구분이 반드시 필요할 때만 (예: `.arch-label`, `.journey-dot`)
- 장식용 이모지/아이콘 금지

### Textures & Decorations

- `.bg-dots`, `.bg-lines`, `.bg-grid`, `.bg-crosshatch` — 시각적 깊이
- `.tape`, `.sticker`, `.stamp`, `.mark` — 수제 느낌
- `.bg-*`, `.p-*`, `.m-*`, `.badge`, `.tag` — inline style 최소화

## File Naming

```
apps/content/src/content/blog/images/{blog-slug}/{blog-slug}-{figure-name}.png
```

## MDX Usage

```mdx
<Figure src="/blog/images/{slug}/{filename}.png" alt="..." caption="..." />
```
