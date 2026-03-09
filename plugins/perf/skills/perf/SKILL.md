---
name: perf
description: Quick performance measurement using Lighthouse and Core Web Vitals that generates performance reports, identifies bottlenecks, and provides optimization recommendations. Use when user says "/perf", "성능 측정", "performance", "lighthouse", or wants to audit page performance. Supports single page or batch measurement.
user-invocable: true
---

# Performance Measurement Skill

Quick Lighthouse audit for web applications.

## Usage

### Commands

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

## Workflow

### 1. Identify Target URLs

If `--all` or batch mode, discover routes using one of the following strategies:

**From sitemap.xml:**
```bash
curl -s https://example.com/sitemap.xml \
  | grep -oP '(?<=<loc>)[^<]+' \
  | head -20
```

**From Next.js / React Router config:**
```bash
# Extract path strings from router/routes file
grep -rE "path:\s*['\"]|route\(['\"]" src/routes* src/app \
  | grep -oP "(?<=path: ['\"]|route\(['\"])[^'\"']+" \
  | sort -u
```

**Fallback — audit key pages manually:**
- Homepage (`/`)
- Main feature pages
- High-traffic routes

### 2. Run Lighthouse

For each URL, invoke `web-perf-ux` skill or run directly:

```bash
lighthouse <url> --output=json --chrome-flags="--headless"
```

### 3. Validate Results

Before proceeding, check that each audit completed successfully:

```bash
# Check exit code and presence of key fields
if [ $? -ne 0 ] || [ -z "$(cat result.json | jq '.categories.performance')" ]; then
  echo "Audit failed for <url> — retrying (attempt 2/3)..."
  sleep 5
  lighthouse <url> --output=json --chrome-flags="--headless"
fi
```

- If an audit fails after 3 retries, mark that URL as `ERROR` and continue to the next.
- Skip malformed or empty JSON results rather than including them in the aggregate.

### 4. Collect Metrics

Focus on Core Web Vitals:

| Metric | Good | Needs Work | Poor |
|--------|------|------------|------|
| LCP (Largest Contentful Paint) | <2.5s | 2.5-4.0s | >4.0s |
| CLS (Cumulative Layout Shift) | <0.1 | 0.1-0.25 | >0.25 |
| INP (Interaction to Next Paint) | <200ms | 200-500ms | >500ms |

Additional metrics:
- FCP (First Contentful Paint)
- TTFB (Time to First Byte)
- Total Blocking Time
- Speed Index

### 5. Generate Report

Aggregate all results and print summary:

```bash
# Aggregate scores from multiple JSON outputs
for f in results/*.json; do
  url=$(jq -r '.finalUrl' "$f")
  score=$(jq '.categories.performance.score * 100 | round' "$f")
  lcp=$(jq -r '.audits["largest-contentful-paint"].displayValue' "$f")
  cls=$(jq -r '.audits["cumulative-layout-shift"].displayValue' "$f")
  inp=$(jq -r '.audits["interaction-to-next-paint"].displayValue // "N/A"' "$f")
  echo "$url | Score: $score | LCP: $lcp | CLS: $cls | INP: $inp"
done
```

Example output:

```
Performance Report
==================
/ (Homepage)
  LCP: 1.8s    CLS: 0.05   INP: 120ms   Score: 92

/dashboard
  LCP: 3.2s    CLS: 0.08   INP: 180ms   Score: 74
  Issues: LCP needs improvement

/products
  LCP: 2.1s    CLS: 0.02   INP: 95ms    Score: 89

Top Issues:
1. /dashboard - Large images not optimized
2. /dashboard - Render-blocking JavaScript
```

## Common Optimizations

Based on results, suggest:

| Issue | Solution |
|-------|----------|
| High LCP | Optimize images, preload critical assets |
| High CLS | Set image dimensions, avoid dynamic content insertion |
| High INP | Reduce JavaScript, use code splitting |
| High TTFB | Check server response, use CDN |

## Integration

This skill works best with `web-perf-ux` plugin for detailed analysis.

```bash
# For detailed analysis
/web-perf-ux https://example.com

# For quick check
/perf https://example.com
```

## Batch Mode

When running `--all`:

1. Discover routes from sitemap or router config (see Step 1 above)
2. Queue pages for measurement
3. Run sequentially (avoid overwhelming server)
4. Validate each result before aggregation (see Step 3 above)
5. Aggregate results into single report using the script in Step 5
