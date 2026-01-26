#!/bin/bash
# Wrap session stop hook
# Suggests running /wrap when session ends with uncommitted changes

if git diff --quiet && git diff --cached --quiet; then
  exit 0
fi

echo "TIP: You have uncommitted changes. Consider running /wrap to analyze and commit your work."
