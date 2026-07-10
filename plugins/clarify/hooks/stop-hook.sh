#!/bin/bash

# Clarify(Interview) Stop Hook
# Prevents session exit while an interview clarification loop is active.
# Re-injects the loop until one of: completion promise, cancellation,
# max iterations, TTL expiry (>2h), or a session-id mismatch.
#
# Runs on both Claude Code and Codex: both send the same Stop-hook JSON on
# stdin (session_id/cwd/transcript_path) and accept the decision:block
# protocol. Codex additionally sends last_assistant_message, which is
# preferred here because the transcript-parsing fallback assumes Claude
# Code's JSONL schema.
#
# State is preserved (retry on the next Stop) for transient conditions —
# transcript momentarily absent, no assistant text yet, jq hiccup.
# The state file is removed only on: corruption, completion, max iterations,
# TTL expiry, or session mismatch.

set -euo pipefail

# Read hook input (JSON) from stdin
HOOK_INPUT=$(cat)

# Resolve state file path from the hook's cwd (fall back to a relative path)
CWD=$(printf '%s' "$HOOK_INPUT" | jq -r '.cwd // empty' 2>/dev/null || true)
if [[ -n "$CWD" ]]; then
  STATE_FILE="$CWD/.claude/clarify-interview.local.md"
  LEGACY_STATE_FILE="$CWD/.claude/clarify-vague.local.md"
else
  STATE_FILE=".claude/clarify-interview.local.md"
  LEGACY_STATE_FILE=".claude/clarify-vague.local.md"
fi

# Pre-3.0 state files can't be resumed (the loop prompt now points at
# clarify:interview), so clear them instead of leaving them stranded.
rm -f "$LEGACY_STATE_FILE" 2>/dev/null || true

# No active loop -> allow exit
if [[ ! -f "$STATE_FILE" ]]; then
  exit 0
fi

SESSION_ID=$(printf '%s' "$HOOK_INPUT" | jq -r '.session_id // empty' 2>/dev/null || true)

# --- Parse frontmatter defensively (a missing field must never abort the script) ---
FRONTMATTER=$(sed -n '/^---$/,/^---$/{ /^---$/d; p; }' "$STATE_FILE" 2>/dev/null || true)

field() {
  # field <key>: value after "<key>:" with surrounding double quotes stripped.
  # Wrapped so a missing field yields "" instead of a pipefail abort.
  printf '%s\n' "$FRONTMATTER" | grep "^$1:" 2>/dev/null | head -1 \
    | sed "s/^$1: *//; s/^\"\(.*\)\"\$/\1/" || true
}

ITERATION=$(field iteration)
MAX_ITERATIONS=$(field max_iterations)
ORIGINAL_REQUIREMENT=$(field original_requirement)
STARTED_AT=$(field started_at)
RECORDED_SESSION=$(field session_id)

# --- Corruption: required numeric fields must be present and valid ---
if ! [[ "$ITERATION" =~ ^[0-9]+$ ]]; then
  echo "Clarify(interview): state file corrupted (iteration invalid: '${ITERATION}'). Cleaning up." >&2
  rm -f "$STATE_FILE"
  exit 0
fi

if ! [[ "$MAX_ITERATIONS" =~ ^[0-9]+$ ]]; then
  echo "Clarify(interview): state file corrupted (max_iterations invalid: '${MAX_ITERATIONS}'). Cleaning up." >&2
  rm -f "$STATE_FILE"
  exit 0
fi

# --- Session binding: record on first fire, reject on mismatch (anti-hijack) ---
if [[ -n "$SESSION_ID" ]]; then
  if [[ -z "$RECORDED_SESSION" ]]; then
    # First hook fire for this state: bind it to the current session.
    TMP="${STATE_FILE}.tmp.$$"
    awk -v sid="$SESSION_ID" '
      !bound && /^---$/ { print; print "session_id: \"" sid "\""; bound=1; next }
      { print }
    ' "$STATE_FILE" > "$TMP" && mv "$TMP" "$STATE_FILE"
    RECORDED_SESSION="$SESSION_ID"
  elif [[ "$RECORDED_SESSION" != "$SESSION_ID" ]]; then
    echo "Clarify(interview): state belongs to a different session. Cleaning up (no re-injection)." >&2
    rm -f "$STATE_FILE"
    exit 0
  fi
fi

# --- TTL: expire loops older than 2 hours (started_at basis) ---
epoch_from_iso() {
  local iso="$1" e trimmed
  # GNU date understands ISO 8601 with offset directly.
  e=$(date -d "$iso" +%s 2>/dev/null || true)
  if [[ -n "$e" ]]; then printf '%s' "$e"; return 0; fi
  # BSD/macOS date: try with explicit offset, then without.
  e=$(date -j -f "%Y-%m-%dT%H:%M:%S%z" "$iso" +%s 2>/dev/null || true)
  if [[ -n "$e" ]]; then printf '%s' "$e"; return 0; fi
  trimmed="${iso%%[+Z]*}"; trimmed="${trimmed%.*}"
  e=$(date -j -f "%Y-%m-%dT%H:%M:%S" "$trimmed" +%s 2>/dev/null || true)
  if [[ -n "$e" ]]; then printf '%s' "$e"; return 0; fi
  return 1
}

if [[ -n "$STARTED_AT" ]]; then
  if STARTED_EPOCH=$(epoch_from_iso "$STARTED_AT"); then
    NOW=$(date +%s)
    if [[ $(( NOW - STARTED_EPOCH )) -gt 7200 ]]; then
      echo "Clarify(interview): TTL expired (>2h). Cleaning up (no re-injection)." >&2
      rm -f "$STATE_FILE"
      exit 0
    fi
  fi
fi

# --- Max iterations reached: stop and ask for the final summary ---
if [[ $MAX_ITERATIONS -gt 0 ]] && [[ $ITERATION -ge $MAX_ITERATIONS ]]; then
  echo "Clarify(interview): max iterations ($MAX_ITERATIONS) reached. Please output the final clarified requirement summary now."
  rm -f "$STATE_FILE"
  exit 0
fi

# --- Last assistant text: Codex sends it inline; Claude Code needs a transcript parse ---
LAST_OUTPUT=$(printf '%s' "$HOOK_INPUT" | jq -r '.last_assistant_message // empty' 2>/dev/null || true)

if [[ -z "$LAST_OUTPUT" ]]; then
  # --- Transcript checks (Claude Code JSONL): transient conditions preserve state and retry ---
  TRANSCRIPT_PATH=$(printf '%s' "$HOOK_INPUT" | jq -r '.transcript_path // empty' 2>/dev/null || true)
  if [[ -z "$TRANSCRIPT_PATH" ]] || [[ ! -f "$TRANSCRIPT_PATH" ]]; then
    # Transcript momentarily absent -> keep state, retry on next Stop.
    exit 0
  fi

  LAST_LINE=$(grep '"role":"assistant"' "$TRANSCRIPT_PATH" 2>/dev/null | tail -1 || true)
  if [[ -z "$LAST_LINE" ]]; then
    # No assistant message yet -> transient, keep state.
    exit 0
  fi

  LAST_OUTPUT=$(printf '%s' "$LAST_LINE" | jq -r '
    .message.content
    | map(select(.type == "text"))
    | map(.text)
    | join("\n")
  ' 2>/dev/null || true)

  if [[ -z "$LAST_OUTPUT" ]]; then
    # No readable assistant text (tool-only turn or jq hiccup) -> transient, keep state.
    exit 0
  fi
fi

# --- Completion promise -> done ---
if printf '%s' "$LAST_OUTPUT" | grep -qF '<promise>CLARIFICATION COMPLETE</promise>'; then
  echo "Clarify(interview): clarification completed."
  rm -f "$STATE_FILE"
  exit 0
fi

# --- Not complete: increment iteration and block exit ---
NEXT_ITERATION=$((ITERATION + 1))

TMP="${STATE_FILE}.tmp.$$"
sed "s/^iteration: .*/iteration: $NEXT_ITERATION/" "$STATE_FILE" > "$TMP"
mv "$TMP" "$STATE_FILE"

PROMPT="Continue clarifying: \"$ORIGINAL_REQUIREMENT\" (iteration $NEXT_ITERATION/$MAX_ITERATIONS).

Re-read '## Clarification Progress' in $STATE_FILE first, then ask only the ambiguities still open, following the clarify:interview SKILL.md rules for how many questions to ask and how to design the options. When no material ambiguity is left, output the Before/After summary and <promise>CLARIFICATION COMPLETE</promise> to finish. If the user has signaled they want to cancel or stop, delete the state file at $STATE_FILE and end the loop."

SYSTEM_MSG="clarify:interview $NEXT_ITERATION/$MAX_ITERATIONS · finish with <promise>CLARIFICATION COMPLETE</promise>"

jq -n \
  --arg prompt "$PROMPT" \
  --arg msg "$SYSTEM_MSG" \
  '{
    "decision": "block",
    "reason": $prompt,
    "systemMessage": $msg
  }'

exit 0
