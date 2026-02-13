# Web Performance & UX Optimization

Optimize web application performance and UX through automated analysis.

## Installation

```bash
# 1. Add marketplace (first time only)
claude plugin marketplace add october-academy/agent-plugins

# 2. Update marketplace
claude plugin marketplace update

# 3. Install plugin
claude plugin install web-perf-ux@october-plugins

# 4. Restart Claude Code
```

## Features

- **Lighthouse-based Measurement**: Performance measurement via CLI or Playwright MCP
- **Core Web Vitals Analysis**: Root cause diagnosis for LCP, CLS, INP issues
- **UX Issue Detection**: Identify layout shifts, slow interactions, and user experience problems
- **Actionable Improvement Plans**: Concrete code-level fix suggestions

## Workflow

```
Measure → Analyze → Explain → Plan
```

1. Measure performance with Lighthouse CLI or Web Vitals script
2. Analyze results against issue catalog and framework patterns
3. Generate structured markdown report (Executive Summary, Scorecard, Findings)
4. Create prioritized task list via Plan/Task tools

## Usage Examples

- "Analyze page performance"
- "Diagnose why my page is slow"
- "Fix CLS issues"
- "Optimize Core Web Vitals"
- "Run Lighthouse"

## Included Resources

### Scripts
- `lighthouse-runner.sh` - Lighthouse CLI wrapper (mobile/desktop, throttling options)
- `collect-vitals.js` - Web Vitals collection script for Playwright

### References
- `core-web-vitals.md` - CWV thresholds and interpretation guide
- `common-issues.md` - Common performance issue catalog (evidence → cause → solution)
- `nextjs.md` - Next.js specific optimization patterns
- `react.md` - React performance patterns

## Requirements

- Playwright MCP server (for browser automation)
- Lighthouse CLI (`npm install -g lighthouse`)

## License

MIT
