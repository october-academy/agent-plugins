# TypeScript LSP for Claude Code

A TypeScript/JavaScript language server that provides code intelligence features for Claude Code.

## Features

- Go-to-definition
- Find references
- Error checking

## Supported File Types

- `.ts` (TypeScript)
- `.tsx` (TypeScript React)
- `.js` (JavaScript)
- `.jsx` (JavaScript React)
- `.mts` (Module TypeScript)
- `.cts` (CommonJS TypeScript)
- `.mjs` (ES Module JavaScript)
- `.cjs` (CommonJS JavaScript)

## Installation

### 1. Install TypeScript Language Server

```bash
npm install -g typescript-language-server typescript
```

Or using yarn:

```bash
yarn global add typescript-language-server typescript
```

### 2. Install Claude Plugin

```bash
# Add marketplace (first time only)
claude plugin marketplace add october-academy/agent-plugins

# Update marketplace
claude plugin marketplace update

# Install plugin
claude plugin install typescript-lsp@october-plugins

# Restart Claude Code
```

## Resources

- [typescript-language-server on npm](https://www.npmjs.com/package/typescript-language-server)
- [GitHub Repository](https://github.com/typescript-language-server/typescript-language-server)
