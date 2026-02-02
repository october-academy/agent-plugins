# Perf

Quick Lighthouse performance audit for web applications.

## Installation

```bash
# 1. Add marketplace (first time only)
claude plugin marketplace add october-academy/claude-plugins

# 2. Update marketplace
claude plugin marketplace update

# 3. Install plugin
claude plugin install perf@october-plugins

# 4. Restart Claude Code
```

## Usage

```bash
/perf                      # Audit current/main page
/perf /about               # Audit specific path
/perf https://example.com  # Audit full URL
/perf --all                # Audit all key pages
```

### Korean Triggers

- "성능 측정"
- "라이트하우스 돌려"
- "페이지 속도 확인"

## Core Web Vitals

| Metric | Good | Needs Work | Poor |
|--------|------|------------|------|
| LCP (Largest Contentful Paint) | <2.5s | 2.5-4.0s | >4.0s |
| CLS (Cumulative Layout Shift) | <0.1 | 0.1-0.25 | >0.25 |
| INP (Interaction to Next Paint) | <200ms | 200-500ms | >500ms |

## How It Works

```
┌───────────────────────────────────────────┐
│  /perf                                     │
└──────────────────┬────────────────────────┘
                   │
                   ▼
┌───────────────────────────────────────────┐
│  1. Identify Target URLs                   │
│     - Single page or batch mode            │
│     - Discover from sitemap/router         │
└──────────────────┬────────────────────────┘
                   │
                   ▼
┌───────────────────────────────────────────┐
│  2. Run Lighthouse                         │
│     lighthouse <url> --output=json         │
└──────────────────┬────────────────────────┘
                   │
                   ▼
┌───────────────────────────────────────────┐
│  3. Generate Report                        │
│     - Core Web Vitals                      │
│     - Score per page                       │
│     - Top issues                           │
└───────────────────────────────────────────┘
```

## Example Output

```
Performance Report
==================
/ (Homepage)
  LCP: 1.8s    CLS: 0.05   INP: 120ms   Score: 92

/dashboard
  LCP: 3.2s    CLS: 0.08   INP: 180ms   Score: 74
  Issues: LCP needs improvement

Top Issues:
1. /dashboard - Large images not optimized
2. /dashboard - Render-blocking JavaScript
```

## Common Optimizations

| Issue | Solution |
|-------|----------|
| High LCP | Optimize images, preload critical assets |
| High CLS | Set image dimensions, avoid dynamic content insertion |
| High INP | Reduce JavaScript, use code splitting |
| High TTFB | Check server response, use CDN |

## Integration

This skill works well with `web-perf-ux` plugin for detailed analysis.

```bash
# For detailed analysis
/web-perf-ux https://example.com

# For quick check
/perf https://example.com
```

## License

MIT
