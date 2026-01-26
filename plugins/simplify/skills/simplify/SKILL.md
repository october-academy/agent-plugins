---
description: Simplify and refine code for clarity, consistency, and maintainability
user-invocable: true
argument-hint: [file or scope]
---

# Code Simplification Skill

Analyze and simplify recently modified code (or specified files) for clarity, consistency, and maintainability while preserving all functionality.

## Scope

- Without arguments: Focus on recently modified code in the current session
- With file/path argument: Focus on the specified file or directory

## Process

1. Identify target code sections
2. Analyze for improvement opportunities
3. Apply project-specific standards from CLAUDE.md
4. Ensure functionality remains unchanged
5. Present simplified code with explanations

## Principles

- **Clarity over Brevity**: Explicit, readable code over compact one-liners
- **No Nested Ternaries**: Use switch/if-else for multiple conditions
- **Reduce Complexity**: Eliminate unnecessary nesting and redundant abstractions
- **Preserve Functionality**: Never change what code does, only how it's written

## Example Improvements

- Nested ternary operators → clear if/else chains
- Deep nesting → early returns or extracted functions
- Redundant abstractions → direct implementations
- Unclear names → descriptive identifiers
