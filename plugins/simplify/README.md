# Simplify

Simplifies and refines code for clarity, consistency, and maintainability while preserving all functionality.

## Installation

```bash
# 1. Add marketplace (first time only)
claude plugin marketplace add october-academy/claude-plugins

# 2. Update marketplace
claude plugin marketplace update

# 3. Install plugin
claude plugin install simplify@october-plugins

# 4. Restart Claude Code
```

## Usage

```bash
/simplify                 # Simplify recently modified code
/simplify src/utils.ts    # Simplify specific file
```

## Architecture

Multi-agent parallel analysis and improvement workflow:

```
┌─────────────────────────────────────────────────────────┐
│  1. Determine Scope (git diff or user input)            │
├─────────────────────────────────────────────────────────┤
│  2. Phase 1: 4 Analysis Agents (Parallel)               │
│     ┌─────────────────┬─────────────────┐               │
│     │  complexity-    │  pattern-       │               │
│     │  analyzer       │  checker        │               │
│     ├─────────────────┼─────────────────┤               │
│     │  naming-        │  readability-   │               │
│     │  reviewer       │  analyzer       │               │
│     └─────────────────┴─────────────────┘               │
├─────────────────────────────────────────────────────────┤
│  3. Consolidate Issues                                  │
├─────────────────────────────────────────────────────────┤
│  4. Phase 2: Issue Simplifiers (Parallel)               │
│     ┌────────┬────────┬────────┬────────┐               │
│     │ issue1 │ issue2 │ issue3 │ ...    │               │
│     └────────┴────────┴────────┴────────┘               │
├─────────────────────────────────────────────────────────┤
│  5. Present Changes & User Selection                    │
├─────────────────────────────────────────────────────────┤
│  6. Apply Selected Changes                              │
└─────────────────────────────────────────────────────────┘
```

## Phase 1 Agents

| Agent | Role |
|-------|------|
| **complexity-analyzer** | Detect nested ternaries, deep nesting, over-abstraction |
| **pattern-checker** | Detect project standard violations, inconsistency issues |
| **naming-reviewer** | Detect variable/function naming improvements, clarity issues |
| **readability-analyzer** | Detect readability issues, unnecessary comments, structural improvements |

## Phase 2

For each issue found in Phase 1, an **issue-simplifier** agent runs in parallel to generate specific code changes.

## Principles

1. **Clarity > Brevity**: Prefer readable code over one-liners
2. **No Nested Ternaries**: Use switch statements or if/else chains
3. **Reduce Complexity**: Remove unnecessary nesting and abstraction
4. **Preserve Functionality**: Never change code behavior

## Improvement Targets

- Unnecessary complexity and deep nesting
- Duplicate code and over-abstraction
- Unclear variable/function names
- Project standard violations
- Dense code that sacrifices readability

## Example

**Before:**
```javascript
const result = items.length > 0 ? items[0].active ? items[0].value : items[0].fallback ?? null : defaultValue;
```

**After:**
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

## License

MIT
