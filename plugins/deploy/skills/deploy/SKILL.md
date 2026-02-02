---
name: deploy
description: Unified deployment for multiple platforms. Supports Railway, Cloudflare Pages, and Cloudflare Workers. Use when user says "/deploy", "배포", "deploy all", "railway 배포", "cloudflare 배포", or any deployment-related request. Supports selective deployment targets.
---

# Deploy Skill

Unified deployment automation for multi-service projects.

## Supported Platforms

| Platform | Command | Use Case |
|----------|---------|----------|
| Railway | `railway up` | Backend services, bots |
| Cloudflare Pages | Git push (auto-deploy) | Static sites |
| Cloudflare Pages (OpenNext) | `bunx @opennextjs/cloudflare build && bunx wrangler deploy` | Next.js SSR apps |
| Cloudflare Workers | `wrangler deploy` | Edge functions |

## Usage

### Commands

```bash
/deploy              # Deploy all services
/deploy railway      # Railway only
/deploy cf           # Cloudflare Workers only
/deploy web          # Next.js app via OpenNext
/deploy opennext     # Same as /deploy web
/deploy pages        # Static sites (git push auto-deploy)
```

### Korean Triggers

- "배포해줘" - full deployment
- "railway 배포" - Railway only
- "cloudflare 배포" - Cloudflare only

## Workflow

### 1. Pre-deployment Check

Before deploying, verify:

```bash
git status                    # Check for uncommitted changes
git log -1 --oneline          # Verify current commit
```

If uncommitted changes exist, ask user whether to:
- Commit first
- Deploy anyway (warn about uncommitted changes)

### 2. Deploy Railway

```bash
cd <project-root>/<service-dir> && railway up
```

Common service directories: `discord-bot/`, `backend/`, `api/`

### 3. Deploy Cloudflare Workers

```bash
cd <project-root>/apps/workers && bunx wrangler deploy
# OR
cd <project-root>/workers && npx wrangler deploy
```

### 4. Cloudflare Pages (Static)

Pages auto-deploys on git push to main branch. Remind user:

```bash
git push origin main
```

Check deployment status at: https://dash.cloudflare.com

### 5. Cloudflare Pages (OpenNext for Next.js)

For Next.js apps with SSR/API routes, use OpenNext:

```bash
cd <project-root>/apps/web && bunx @opennextjs/cloudflare build && bunx wrangler deploy
```

This builds the Next.js app for Cloudflare Workers runtime and deploys it.

## Post-deployment

After successful deployment:

1. Report status for each service
2. Provide relevant URLs/dashboards
3. Note any warnings or errors

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
