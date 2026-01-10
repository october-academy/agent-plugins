#!/bin/bash

# Clarify Ralph Stop Hook
# Prevents session exit when clarify-ralph loop is active
# Continues clarification until completion or max iterations

set -euo pipefail

# Read hook input from stdin
HOOK_INPUT=$(cat)

# Check if clarify-ralph loop is active
STATE_FILE=".claude/clarify-ralph.local.md"

if [[ ! -f "$STATE_FILE" ]]; then
  # No active loop - allow exit
  exit 0
fi

# Parse frontmatter (YAML between --- markers)
FRONTMATTER=$(sed -n '/^---$/,/^---$/{ /^---$/d; p; }' "$STATE_FILE")
ITERATION=$(echo "$FRONTMATTER" | grep '^iteration:' | sed 's/iteration: *//')
MAX_ITERATIONS=$(echo "$FRONTMATTER" | grep '^max_iterations:' | sed 's/max_iterations: *//')
ORIGINAL_REQUIREMENT=$(echo "$FRONTMATTER" | grep '^original_requirement:' | sed 's/original_requirement: *//' | sed 's/^"\(.*\)"$/\1/')

# Validate numeric fields
if [[ ! "$ITERATION" =~ ^[0-9]+$ ]]; then
  echo "Clarify Ralph: State file corrupted (iteration field invalid)" >&2
  rm "$STATE_FILE"
  exit 0
fi

if [[ ! "$MAX_ITERATIONS" =~ ^[0-9]+$ ]]; then
  echo "Clarify Ralph: State file corrupted (max_iterations field invalid)" >&2
  rm "$STATE_FILE"
  exit 0
fi

# Check if max iterations reached
if [[ $MAX_ITERATIONS -gt 0 ]] && [[ $ITERATION -ge $MAX_ITERATIONS ]]; then
  echo "Clarify Ralph: Max iterations ($MAX_ITERATIONS) reached."
  echo "Please output the final clarified requirement summary now."
  rm "$STATE_FILE"
  exit 0
fi

# Get transcript path from hook input
TRANSCRIPT_PATH=$(echo "$HOOK_INPUT" | jq -r '.transcript_path')

if [[ ! -f "$TRANSCRIPT_PATH" ]]; then
  echo "Clarify Ralph: Transcript file not found" >&2
  rm "$STATE_FILE"
  exit 0
fi

# Check for assistant messages in transcript
if ! grep -q '"role":"assistant"' "$TRANSCRIPT_PATH"; then
  echo "Clarify Ralph: No assistant messages found in transcript" >&2
  rm "$STATE_FILE"
  exit 0
fi

# Extract last assistant message (JSONL format)
LAST_LINE=$(grep '"role":"assistant"' "$TRANSCRIPT_PATH" | tail -1)
if [[ -z "$LAST_LINE" ]]; then
  rm "$STATE_FILE"
  exit 0
fi

LAST_OUTPUT=$(echo "$LAST_LINE" | jq -r '
  .message.content |
  map(select(.type == "text")) |
  map(.text) |
  join("\n")
' 2>/dev/null || echo "")

if [[ -z "$LAST_OUTPUT" ]]; then
  rm "$STATE_FILE"
  exit 0
fi

# Check for completion promise
COMPLETION_PROMISE="CLARIFICATION COMPLETE"
PROMISE_TEXT=$(echo "$LAST_OUTPUT" | perl -0777 -pe 's/.*?<promise>(.*?)<\/promise>.*/$1/s; s/^\s+|\s+$//g; s/\s+/ /g' 2>/dev/null || echo "")

if [[ -n "$PROMISE_TEXT" ]] && [[ "$PROMISE_TEXT" = "$COMPLETION_PROMISE" ]]; then
  echo "Clarify Ralph: Clarification completed successfully!"
  rm "$STATE_FILE"
  exit 0
fi

# Not complete - continue loop with same prompt
NEXT_ITERATION=$((ITERATION + 1))

# Update iteration count in state file
TEMP_FILE="${STATE_FILE}.tmp.$$"
sed "s/^iteration: .*/iteration: $NEXT_ITERATION/" "$STATE_FILE" > "$TEMP_FILE"
mv "$TEMP_FILE" "$STATE_FILE"

# Build prompt for next iteration
PROMPT="Continue clarifying the requirement: \"$ORIGINAL_REQUIREMENT\"

This is iteration $NEXT_ITERATION of $MAX_ITERATIONS.

Review the conversation history to see previous questions and answers, then:

1. Identify ambiguities that haven't been addressed yet
2. Ask exactly 4 questions using AskUserQuestion tool, each with exactly 4 options
3. The 4th question's 4th option should be \"Clarification complete - proceed with current understanding\"
4. When user confirms completion, output the Before/After summary and <promise>CLARIFICATION COMPLETE</promise>

Remember: Only output the promise when clarification is GENUINELY complete. Do not lie to exit."

SYSTEM_MSG="Clarify Ralph iteration $NEXT_ITERATION/$MAX_ITERATIONS | Complete: <promise>CLARIFICATION COMPLETE</promise>"

# Block exit and feed prompt back to Claude
jq -n \
  --arg prompt "$PROMPT" \
  --arg msg "$SYSTEM_MSG" \
  '{
    "decision": "block",
    "reason": $prompt,
    "systemMessage": $msg
  }'

exit 0
