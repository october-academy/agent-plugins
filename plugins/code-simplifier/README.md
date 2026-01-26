# Code Simplifier

An autonomous agent that simplifies and refines code for clarity, consistency, and maintainability while preserving all functionality.

## Installation

```bash
# 1. Add marketplace (first time only)
claude plugin marketplace add october/claude-plugins

# 2. Update marketplace
claude plugin marketplace update

# 3. Install plugin
claude plugin install code-simplifier@october-plugins

# 4. Restart Claude Code
```

## Features

- **Autonomous Operation**: Runs proactively without explicit requests, refining code immediately after it's written or modified
- **Powered by Opus**: Uses Claude Opus for high-quality code analysis and refinement
- **Functionality Preservation**: Never changes what code does - only improves how it's written
- **Project-Aware**: Follows established coding standards from your CLAUDE.md

## Core Principles

The agent applies these refinement principles:

1. **Clarity over Brevity**: Explicit, readable code is preferred over compact one-liners
2. **Avoid Nested Ternaries**: Uses switch statements or if/else chains for multiple conditions
3. **Reduce Complexity**: Eliminates unnecessary nesting and redundant abstractions
4. **Maintain Balance**: Avoids over-simplification that could reduce maintainability

## What It Improves

- Unnecessary complexity and deep nesting
- Redundant code and abstractions
- Unclear variable and function names
- Overly clever solutions that are hard to understand
- Dense one-liners that sacrifice readability

## Scope

By default, the agent focuses on recently modified code in the current session. It can be instructed to review a broader scope when needed.

## Example

Before:
```javascript
const result = items.length > 0 ? items[0].active ? items[0].value : items[0].fallback ? items[0].fallback : null : defaultValue;
```

After:
```javascript
function getItemValue(items, defaultValue) {
  if (items.length === 0) {
    return defaultValue;
  }

  const firstItem = items[0];

  if (firstItem.active) {
    return firstItem.value;
  }

  return firstItem.fallback ?? null;
}
```
