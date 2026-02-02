# Deploy

Unified deployment automation for Railway, Cloudflare Pages, and Workers.

## Installation

```bash
# 1. Add marketplace (first time only)
claude plugin marketplace add october-academy/claude-plugins

# 2. Update marketplace
claude plugin marketplace update

# 3. Install plugin
claude plugin install deploy@october-plugins

# 4. Restart Claude Code
```

## Usage

```bash
/deploy              # Deploy all services
/deploy railway      # Railway only
/deploy cf           # Cloudflare Workers only
/deploy pages        # Remind about Pages auto-deploy
```

### Korean Triggers

- "배포해줘" - full deployment
- "railway 배포" - Railway only
- "cloudflare 배포" - Cloudflare only

## Supported Platforms

| Platform | Command | Use Case |
|----------|---------|----------|
| Railway | `railway up` | Backend services, bots |
| Cloudflare Pages | Git push (auto-deploy) | Static sites, SSR apps |
| Cloudflare Workers | `wrangler deploy` | Edge functions |

## How It Works

```
┌───────────────────────────────────────────┐
│  /deploy                                   │
└──────────────────┬────────────────────────┘
                   │
                   ▼
┌───────────────────────────────────────────┐
│  1. Pre-deployment Check                   │
│     - Uncommitted changes?                 │
│     - Verify current commit                │
└──────────────────┬────────────────────────┘
                   │
                   ▼
┌───────────────────────────────────────────┐
│  2. Deploy Each Service                    │
│     - Railway: railway up                  │
│     - Workers: wrangler deploy             │
│     - Pages: git push (auto-deploy)        │
└──────────────────┬────────────────────────┘
                   │
                   ▼
┌───────────────────────────────────────────┐
│  3. Post-deployment Report                 │
│     - Status for each service              │
│     - URLs and dashboard links             │
└───────────────────────────────────────────┘
```

## Configuration

Projects should have these in their root or service directories:

- `railway.toml` - Railway configuration
- `wrangler.toml` - Cloudflare Workers configuration

## Error Handling

| Error | Solution |
|-------|----------|
| "Not logged in" | Run `railway login` or `wrangler login` |
| "Project not found" | Run `railway link` or check `wrangler.toml` |
| "Build failed" | Check build logs, fix issues, retry |

## License

MIT
