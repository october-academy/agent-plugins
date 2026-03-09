# Blog Figure

Neo-Brutalism style figure images (PNG) for blog posts. HTML → browser capture → PNG pipeline.

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

- "figure 만들어", "블로그 이미지", "다이어그램 생성"
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
│  2. Choose pattern                      │
│     (comparison, flow, timeline,        │
│      concept)                           │
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
│     Chrome DevTools / Playwright / CLI   │
└──────────────────┬──────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────┐
│  5. Save to project images directory    │
└─────────────────────────────────────────┘
```

## Patterns

| Pattern | Use Case |
|---------|----------|
| **Comparison** | X vs Y, before/after |
| **Flow** | Step-by-step process |
| **Timeline** | Time allocation, proportions |
| **Concept** | Relationships, concept diagrams |
| **Waffle** | Percentage, proportions |
| **Typographic** | Editorial quotes, definitions |
| **Slope** | Rank changes, before/after |
| **Treemap** | Area-proportional composition |
| **Radar** | Multi-dimensional comparison |
| **Dumbbell** | Gap between two values |
| **Heatmap** | 2D frequency/density |
| **Bullet** | Actual vs target KPI |
| **Sparkline Grid** | Multi-item trend summary |
| **Waterfall** | Incremental change breakdown |

## Design Rules

- **Size**: 1440x810 (16:9)
- **Border**: 3px solid #0a0a0a
- **Shadow**: Npx Npx 0px #0a0a0a (no blur)
- **Fonts**: Noto Sans KR 900 (titles), Noto Sans KR 700 (body)
- **Colors**: CSS variables only
- **Icons**: Emoji only (self-contained HTML)

## License

MIT
