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
- **Title font**: Black Han Sans
- **Body font**: Noto Sans KR
- **Colors**: CSS variables only — never hardcode hex in HTML
- **Icons**: Emoji (not FontAwesome — keeps HTML self-contained)
- **No**: gradients, blur shadows, soft edges

## File Naming

```
apps/content/src/content/blog/images/{blog-slug}/{blog-slug}-{figure-name}.png
```

## MDX Usage

```mdx
<Figure src="/blog/images/{slug}/{filename}.png" alt="..." caption="..." />
```
