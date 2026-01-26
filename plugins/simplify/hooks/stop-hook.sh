#!/bin/bash
# Simplify session stop hook
# Suggests running /simplify when session ends with code changes

CHANGED_FILES=$(git diff --name-only HEAD 2>/dev/null | grep -E '\.(ts|tsx|js|jsx|py|go|rs|java)$' | wc -l | tr -d ' ')

if [ "$CHANGED_FILES" -gt 0 ]; then
  echo "TIP: You modified $CHANGED_FILES code file(s). Consider running /simplify to review for clarity improvements."
fi
