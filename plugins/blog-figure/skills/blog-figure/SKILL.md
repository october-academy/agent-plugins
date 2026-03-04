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

1. **Understand context**: Read blog MDX or user description to decide what to visualize
2. **Choose pattern**: Pick from 15 patterns — see [references/figure-patterns.md](references/figure-patterns.md)
3. **Create HTML**: Write standalone HTML to `/tmp/blog-figure-{name}.html` linking `assets/figure.css`
4. **Capture PNG**: Open in browser, screenshot at 1440×810, save PNG
5. **Save to project**: Move PNG to `apps/content/src/content/blog/images/{slug}/`
6. **Verify**: Read the saved PNG to visually confirm

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

Full HTML examples for each: [references/figure-patterns.md](references/figure-patterns.md)

## Design Rules

- **Size**: 1440×810 (16:9)
- **Border**: 3px solid #0a0a0a
- **Shadow**: Npx Npx 0px #0a0a0a (no blur ever)
- **Title font**: Black Han Sans (headings/labels only)
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

### Weight Hierarchy

| Role | Weight | Example |
|------|--------|---------|
| 모든 텍스트 기본값 | 700 | body default, `.flow-card`, `.journey-desc` |
| 부연/보조 (드물게 사용) | 400 | 긴 설명이 불가피할 때만 |
| Display titles | Black Han Sans | `.figure-title`, `.section-label` |

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
