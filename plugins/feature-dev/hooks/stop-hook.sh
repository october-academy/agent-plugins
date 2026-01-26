#!/bin/bash
# Feature-dev session stop hook
# Suggests next steps after feature development session

CHANGED_FILES=$(git diff --name-only HEAD 2>/dev/null | wc -l | tr -d ' ')

if [ "$CHANGED_FILES" -gt 5 ]; then
  echo "TIP: Significant changes detected ($CHANGED_FILES files). Consider:"
  echo "  - Running tests to verify functionality"
  echo "  - Creating a PR with /git:push-pr"
  echo "  - Wrapping up with /wrap"
fi
