#!/bin/bash

# Clarify(Interview) Stop Hook
# Prevents session exit while an interview clarification loop is active.
# Re-injects the loop until one of: terminal promise, cancellation,
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
# TTL expiry, or a session mismatch.
#
# The hook owns state-file deletion. A companion guard file (written on every
# decision:block) closes the self-delete bypass: if the model deletes the
# state file itself and then claims COMPLETE at a consumed budget, the guard
# still carries the iteration/max snapshot and the false COMPLETE gets the
# same fail-closed retraction it would have gotten with the state intact.

set -euo pipefail

# Read hook input (JSON) from stdin
HOOK_INPUT=$(cat)

# Resolve state/guard paths from the hook's cwd (fall back to relative paths)
CWD=$(printf '%s' "$HOOK_INPUT" | jq -r '.cwd // empty' 2>/dev/null || true)
if [[ -n "$CWD" ]]; then
  STATE_FILE="$CWD/.claude/clarify-interview.local.md"
  GUARD_FILE="$CWD/.claude/clarify-interview.guard"
  LEGACY_STATE_FILE="$CWD/.claude/clarify-vague.local.md"
else
  STATE_FILE=".claude/clarify-interview.local.md"
  GUARD_FILE=".claude/clarify-interview.guard"
  LEGACY_STATE_FILE=".claude/clarify-vague.local.md"
fi

# Pre-3.0 state files can't be resumed (the loop prompt now points at
# clarify:interview), so clear them instead of leaving them stranded.
rm -f "$LEGACY_STATE_FILE" 2>/dev/null || true

SESSION_ID=$(printf '%s' "$HOOK_INPUT" | jq -r '.session_id // empty' 2>/dev/null || true)

# resolve_last_output: sets LAST_OUTPUT from the Codex inline field or the
# Claude Code transcript. Empty result = transient / nothing readable.
resolve_last_output() {
  LAST_OUTPUT=$(printf '%s' "$HOOK_INPUT" | jq -r '.last_assistant_message // empty' 2>/dev/null || true)
  if [[ -n "$LAST_OUTPUT" ]]; then return 0; fi
  local transcript_path last_line
  transcript_path=$(printf '%s' "$HOOK_INPUT" | jq -r '.transcript_path // empty' 2>/dev/null || true)
  if [[ -z "$transcript_path" ]] || [[ ! -f "$transcript_path" ]]; then return 0; fi
  last_line=$(grep '"role":"assistant"' "$transcript_path" 2>/dev/null | tail -1 || true)
  if [[ -z "$last_line" ]]; then return 0; fi
  LAST_OUTPUT=$(printf '%s' "$last_line" | jq -r '
    .message.content
    | map(select(.type == "text"))
    | map(.text)
    | join("\n")
  ' 2>/dev/null || true)
}

# write_guard <iteration> <max_iterations>: snapshot the loop position so a
# model-side state deletion can't erase the cap evidence before the next Stop.
# Monotonic — an existing guard's iteration is never lowered (the skill also
# updates the guard mid-turn; a hook snapshot must not roll that back), and an
# existing creation epoch is preserved byte-for-byte (re-stamping would extend
# the TTL past the loop's real age). When creating a fresh guard the epoch
# derives from the loop's started_at, falling back to now. A write failure is
# loud, never silent: the tamper defense being degraded is something the
# transcript must show.
write_guard() {
  local new_iter="$1" new_max="$2" cur_iter cur_epoch epoch
  if [[ -f "$GUARD_FILE" ]]; then
    cur_iter=$(head -1 "$GUARD_FILE" 2>/dev/null | awk '{print $1}' || true)
    cur_epoch=$(head -1 "$GUARD_FILE" 2>/dev/null | awk '{print $4}' || true)
    if [[ "$cur_iter" =~ ^[0-9]+$ ]] && [[ $cur_iter -gt $new_iter ]]; then
      new_iter="$cur_iter"
    fi
  fi
  if [[ "${cur_epoch:-}" =~ ^[0-9]+$ ]]; then
    epoch="$cur_epoch"
  elif [[ -n "${STARTED_AT:-}" ]] && epoch=$(epoch_from_iso "$STARTED_AT"); then
    :
  else
    epoch=$(date +%s)
  fi
  if ! printf '%s %s %s %s\n' "$new_iter" "$new_max" "${SESSION_ID:-_}" "$epoch" > "$GUARD_FILE" 2>/dev/null; then
    echo "Clarify(interview): WARNING — failed to write guard file at $GUARD_FILE; self-delete tamper defense is degraded for this loop." >&2
  fi
}

retraction_block() {
  jq -n \
    --arg prompt "You emitted COMPLETE at the consumed round budget after the loop had already reached its cap. Do not restart the interview. Output one final line stating: the clarification is CAPPED, not COMPLETE — the round budget was fully consumed, so undiscovered material axes cannot be ruled out and the summary's COMPLETE tag should be read as <promise>CLARIFICATION CAPPED</promise>. Then stop." \
    --arg msg "clarify:interview cap violation · COMPLETE retracted, correction requested (loop state cleared)" \
    '{"decision": "block", "reason": $prompt, "systemMessage": $msg}'
}

# ambiguity_reemit_block <n_tags> <n_complete> <n_capped>: once-only request
# to re-emit the summary with exactly one terminal tag.
ambiguity_reemit_block() {
  jq -n \
    --arg prompt "Your summary carries $1 terminal promise tags (COMPLETE x$2, CAPPED x$3). Exactly one is required so hooks and tooling can parse the outcome. Re-emit the same Before/After summary ending with exactly one correct tag. Do not delete the state file — this hook removes it after validating the tag." \
    --arg msg "clarify:interview ambiguous terminal tags · re-emit with exactly one tag" \
    '{"decision": "block", "reason": $prompt, "systemMessage": $msg}'
}

# ambiguity_correction_block: terminal close for repeated multi-tag output —
# the loop ends, but never silently: the ambiguous summary gets an explicit
# on-record correction, mirroring retraction_block.
ambiguity_correction_block() {
  jq -n \
    --arg prompt "Your summary still carries multiple terminal promise tags after being asked to re-emit with exactly one. Do not restart the interview. Output one final line stating: the terminal tags were ambiguous, and the summary should be read conservatively as <promise>CLARIFICATION CAPPED</promise> (exactly one tag). Then stop." \
    --arg msg "clarify:interview ambiguous tags persisted · conservative CAPPED correction requested (loop state cleared)" \
    '{"decision": "block", "reason": $prompt, "systemMessage": $msg}'
}

# count_tag <tag>: occurrences (not lines) of a tag in LAST_OUTPUT
count_tag() {
  printf '%s' "$LAST_OUTPUT" | grep -oF "$1" | wc -l | tr -d ' ' || true
}

# --- No state file: either no loop, or the model deleted it itself ---
if [[ ! -f "$STATE_FILE" ]]; then
  if [[ ! -f "$GUARD_FILE" ]]; then
    exit 0
  fi
  # Guard without state = the loop was active and the model cleaned the state
  # file itself (legitimate for CAPPED/off-cap COMPLETE/cancellation — but a
  # COMPLETE at a consumed budget must still be caught). The guard is consumed
  # ONLY when a terminal tag can actually be judged: transient output and
  # readable-but-non-terminal output both preserve it — otherwise one tag-less
  # Stop would launder the evidence away before the COMPLETE arrives.
  G_LINE=$(head -1 "$GUARD_FILE" 2>/dev/null || true)
  G_ITER=$(printf '%s' "$G_LINE" | awk '{print $1}')
  G_MAX=$(printf '%s' "$G_LINE" | awk '{print $2}')
  G_SESSION=$(printf '%s' "$G_LINE" | awk '{print $3}')
  G_EPOCH=$(printf '%s' "$G_LINE" | awk '{print $4}')
  G_AMBIG=$(printf '%s' "$G_LINE" | awk '{print $5}')
  # The epoch is mandatory (both writers stamp it at creation) — a guard
  # without one has no anchored TTL and could resurrect indefinitely stale
  # loops, so it is rejected loudly rather than adopted.
  if ! [[ "$G_EPOCH" =~ ^[0-9]+$ ]]; then
    echo "Clarify(interview): guard at $GUARD_FILE has no creation epoch — rejecting it (malformed)." >&2
    rm -f "$GUARD_FILE"
    exit 0
  fi
  if [[ $(( $(date +%s) - G_EPOCH )) -gt 7200 ]]; then
    rm -f "$GUARD_FILE"
    exit 0  # guard TTL expired (creation-anchored)
  fi
  if [[ -n "$SESSION_ID" && -n "$G_SESSION" && "$G_SESSION" != "_" && "$G_SESSION" != "$SESSION_ID" ]]; then
    rm -f "$GUARD_FILE"
    exit 0  # stale guard from another session
  fi
  LAST_OUTPUT=""
  resolve_last_output
  if [[ -z "$LAST_OUTPUT" ]]; then
    # Transient: nothing readable this Stop — keep the guard, judge next time.
    exit 0
  fi
  N_COMPLETE=$(count_tag '<promise>CLARIFICATION COMPLETE</promise>')
  N_CAPPED=$(count_tag '<promise>CLARIFICATION CAPPED</promise>')
  N_TAGS=$(( ${N_COMPLETE:-0} + ${N_CAPPED:-0} ))
  if [[ $N_TAGS -eq 0 ]]; then
    # Readable but non-terminal: preserve the guard; bind a wildcard guard to
    # this session on first observation (the creation epoch is preserved).
    if [[ "$G_SESSION" == "_" ]]; then
      printf '%s %s %s %s %s\n' "$G_ITER" "$G_MAX" "${SESSION_ID:-_}" "$G_EPOCH" "${G_AMBIG:-}" > "$GUARD_FILE" 2>/dev/null \
        || echo "Clarify(interview): WARNING — failed to rebind guard at $GUARD_FILE." >&2
    fi
    exit 0
  fi
  # Same terminal invariants as the state path: at a consumed budget any
  # COMPLETE fails closed; otherwise exactly one tag is required.
  GUARD_AT_CAP=0
  if [[ "$G_ITER" =~ ^[0-9]+$ ]] && [[ "$G_MAX" =~ ^[0-9]+$ ]] \
     && [[ $G_MAX -gt 0 ]] && [[ $G_ITER -ge $G_MAX ]]; then GUARD_AT_CAP=1; fi
  if [[ $GUARD_AT_CAP -eq 1 ]] && [[ ${N_COMPLETE:-0} -gt 0 ]]; then
    rm -f "$GUARD_FILE"
    echo "Clarify(interview): state file was self-deleted with a COMPLETE at the consumed budget — failing closed." >&2
    retraction_block
    exit 0
  fi
  if [[ $N_TAGS -eq 1 ]]; then
    rm -f "$GUARD_FILE"
    exit 0
  fi
  # Multiple tags on the guard path: once-only re-emit request (marked on the
  # guard itself), then the explicit conservative correction — never a silent
  # first-sight acceptance.
  if [[ "$G_AMBIG" == "ambig" ]]; then
    rm -f "$GUARD_FILE"
    ambiguity_correction_block
    exit 0
  fi
  printf '%s %s %s %s ambig\n' "$G_ITER" "$G_MAX" "${SESSION_ID:-${G_SESSION:-_}}" "$G_EPOCH" > "$GUARD_FILE" 2>/dev/null \
    || echo "Clarify(interview): WARNING — failed to mark guard ambiguity at $GUARD_FILE." >&2
  ambiguity_reemit_block "$N_TAGS" "${N_COMPLETE:-0}" "${N_CAPPED:-0}"
  exit 0
fi

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
  rm -f "$STATE_FILE" "$GUARD_FILE"
  exit 0
fi

if ! [[ "$MAX_ITERATIONS" =~ ^[0-9]+$ ]]; then
  echo "Clarify(interview): state file corrupted (max_iterations invalid: '${MAX_ITERATIONS}'). Cleaning up." >&2
  rm -f "$STATE_FILE" "$GUARD_FILE"
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
    rm -f "$STATE_FILE" "$GUARD_FILE"
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
      rm -f "$STATE_FILE" "$GUARD_FILE"
      exit 0
    fi
  fi
fi

# --- Last assistant text: Codex sends it inline; Claude Code needs a transcript parse ---
LAST_OUTPUT=""
resolve_last_output

if [[ -z "$LAST_OUTPUT" ]]; then
  # Transient (transcript momentarily absent / no assistant text / jq hiccup)
  # -> keep state, retry on next Stop.
  exit 0
fi

# --- Terminal promise handling: all tag occurrences are counted BEFORE any
# cleanup. Exactly one tag is required; at a consumed budget any COMPLETE
# occurrence (even alongside a CAPPED) is dishonest and fails closed.
N_COMPLETE=$(count_tag '<promise>CLARIFICATION COMPLETE</promise>')
N_CAPPED=$(count_tag '<promise>CLARIFICATION CAPPED</promise>')
N_TAGS=$(( ${N_COMPLETE:-0} + ${N_CAPPED:-0} ))
AT_CAP=0
if [[ $MAX_ITERATIONS -gt 0 ]] && [[ $ITERATION -ge $MAX_ITERATIONS ]]; then AT_CAP=1; fi

if [[ $N_TAGS -gt 0 ]]; then
  if [[ $AT_CAP -eq 1 ]] && [[ ${N_COMPLETE:-0} -gt 0 ]]; then
    # A fully-consumed budget cannot honestly claim completeness (unconceived
    # axes can't be ruled out from a spent budget) — COMPLETE is never
    # accepted at the cap, including mixed COMPLETE+CAPPED outputs. First
    # occurrence: ask for a CAPPED re-emit. Repeated: fail closed with an
    # explicit correction so the false COMPLETE never stands as success.
    COMPLETE_REJECTED=$(field cap_complete_rejected)
    if [[ "$COMPLETE_REJECTED" == "true" ]]; then
      rm -f "$STATE_FILE" "$GUARD_FILE"
      retraction_block
      exit 0
    fi
    TMP="${STATE_FILE}.tmp.$$"
    awk '
      !marked && /^---$/ { print; print "cap_complete_rejected: \"true\""; marked=1; next }
      { print }
    ' "$STATE_FILE" > "$TMP" && mv "$TMP" "$STATE_FILE"
    write_guard "$ITERATION" "$MAX_ITERATIONS"
    jq -n \
      --arg prompt "You emitted <promise>CLARIFICATION COMPLETE</promise> after consuming the full round budget ($ITERATION/$MAX_ITERATIONS). A spent budget cannot rule out material axes you never conceived of, so COMPLETE is not an honest tag here. Re-emit the same Before/After summary ending with exactly one tag, <promise>CLARIFICATION CAPPED</promise>; under Still Open add either the un-asked material axes, or the single line \`라운드 예산 소진 — 미탐지 축 잔존 가능성, 구현 첫 리뷰에서 재확인\` if every conceived axis was resolved. Do not delete the state file — this hook removes it after validating the tag." \
      --arg msg "clarify:interview budget consumed · re-emit summary with the CAPPED tag" \
      '{"decision": "block", "reason": $prompt, "systemMessage": $msg}'
    exit 0
  fi
  if [[ $N_TAGS -eq 1 ]]; then
    if [[ ${N_CAPPED:-0} -eq 1 ]]; then
      echo "Clarify(interview): clarification ended (capped)."
    else
      echo "Clarify(interview): clarification ended."
    fi
    rm -f "$STATE_FILE" "$GUARD_FILE"
    exit 0
  fi
  # Multiple tags without a dishonest cap-COMPLETE (e.g. duplicated CAPPED, or
  # COMPLETE+CAPPED below the cap): ambiguous — request a single-tag re-emit
  # exactly once; if it repeats, close with the explicit conservative
  # correction (never a silent termination on ambiguous tags).
  TAG_RETRY=$(field tag_ambiguity_rejected)
  if [[ "$TAG_RETRY" == "true" ]]; then
    rm -f "$STATE_FILE" "$GUARD_FILE"
    ambiguity_correction_block
    exit 0
  fi
  TMP="${STATE_FILE}.tmp.$$"
  awk '
    !marked && /^---$/ { print; print "tag_ambiguity_rejected: \"true\""; marked=1; next }
    { print }
  ' "$STATE_FILE" > "$TMP" && mv "$TMP" "$STATE_FILE"
  write_guard "$ITERATION" "$MAX_ITERATIONS"
  ambiguity_reemit_block "$N_TAGS" "${N_COMPLETE:-0}" "${N_CAPPED:-0}"
  exit 0
fi

# --- Plain-text question turn: hand control back to the user exactly once ---
# When no structured-question tool exists, the skill prints numbered questions
# and must END the turn so the user can reply. It marks that by setting
# awaiting_user: "true" in the frontmatter. We flip the flag (one free pass per
# question batch) and allow exit with state preserved; the next promise-less
# turn end blocks as usual. The pass is only honored when the turn actually
# printed an answerable question batch — at least two numbered option tokens
# plus a question signal ('?' or a 기타 escape option). A bare flag, or
# numbered non-questions like "1) 진행 상황 정리", would strand the session
# (nothing re-invokes the model until the user happens to reply), so those
# burn the flag and fall through to normal re-injection.
AWAITING=$(field awaiting_user)
if [[ "$AWAITING" == "true" ]]; then
  TMP="${STATE_FILE}.tmp.$$"
  sed 's/^awaiting_user: .*/awaiting_user: "false"/' "$STATE_FILE" > "$TMP" && mv "$TMP" "$STATE_FILE"
  OPTION_TOKENS=$(printf '%s' "$LAST_OUTPUT" | grep -oE '[0-9]+[).]' | wc -l | tr -d ' ' || true)
  HAS_QUESTION_SIGNAL=0
  if printf '%s' "$LAST_OUTPUT" | grep -qE '\?|기타'; then HAS_QUESTION_SIGNAL=1; fi
  if [[ "${OPTION_TOKENS:-0}" -ge 2 ]] && [[ $HAS_QUESTION_SIGNAL -eq 1 ]]; then
    echo "Clarify(interview): plain-text questions pending — yielding to the user." >&2
    exit 0
  fi
  echo "Clarify(interview): awaiting_user set but the turn carries no answerable question batch — resuming the loop." >&2
fi

# --- Max iterations reached without a terminal promise: request the final
# summary exactly once via decision:block (a plain echo never reaches the
# model), then clean up if it still doesn't arrive. cap_summary_requested in
# the frontmatter is the once-only marker.
if [[ $MAX_ITERATIONS -gt 0 ]] && [[ $ITERATION -ge $MAX_ITERATIONS ]]; then
  CAP_REQUESTED=$(field cap_summary_requested)
  if [[ "$CAP_REQUESTED" == "true" ]]; then
    echo "Clarify(interview): cap summary already requested and still no terminal promise. Cleaning up." >&2
    rm -f "$STATE_FILE" "$GUARD_FILE"
    exit 0
  fi
  TMP="${STATE_FILE}.tmp.$$"
  awk '
    !marked && /^---$/ { print; print "cap_summary_requested: \"true\""; marked=1; next }
    { print }
  ' "$STATE_FILE" > "$TMP" && mv "$TMP" "$STATE_FILE"
  write_guard "$ITERATION" "$MAX_ITERATIONS"

  CAP_PROMPT="Max iterations ($MAX_ITERATIONS) reached for: \"$ORIGINAL_REQUIREMENT\". Do not ask any more questions.

Re-read '## Clarification Progress' in $STATE_FILE, then output the Before/After summary now. Any material axis you never got to ask goes under Still Open labeled un-asked (e.g. \`미질문 — 라운드 예산 소진\`) with how it gets resolved — never as an assumption with a concrete default; if every conceived axis was resolved, Still Open carries the single line \`라운드 예산 소진 — 미탐지 축 잔존 가능성, 구현 첫 리뷰에서 재확인\`. End with <promise>CLARIFICATION CAPPED</promise> — the budget is spent, so COMPLETE is not available. Do not delete the state file — this hook removes it after validating the tag."

  jq -n \
    --arg prompt "$CAP_PROMPT" \
    --arg msg "clarify:interview cap reached · finish with the final summary + promise tag" \
    '{
      "decision": "block",
      "reason": $prompt,
      "systemMessage": $msg
    }'
  exit 0
fi

# --- Not complete: increment iteration and block exit ---
NEXT_ITERATION=$((ITERATION + 1))

TMP="${STATE_FILE}.tmp.$$"
sed "s/^iteration: .*/iteration: $NEXT_ITERATION/" "$STATE_FILE" > "$TMP"
mv "$TMP" "$STATE_FILE"
write_guard "$NEXT_ITERATION" "$MAX_ITERATIONS"

PROMPT="Continue clarifying: \"$ORIGINAL_REQUIREMENT\" (iteration $NEXT_ITERATION/$MAX_ITERATIONS).

Re-read '## Clarification Progress' in $STATE_FILE first, then ask only the ambiguities still open, following the clarify:interview SKILL.md rules for how many questions to ask and how to design the options. When no material ambiguity is left, output the Before/After summary and the terminal promise tag to finish — <promise>CLARIFICATION COMPLETE</promise> while budget remains, <promise>CLARIFICATION CAPPED</promise> if this is the final round. Leave the state file in place — this hook removes it after validating the tag. If the user has signaled they want to cancel or stop, delete the state file at $STATE_FILE and end the loop."

SYSTEM_MSG="clarify:interview $NEXT_ITERATION/$MAX_ITERATIONS · finish with a terminal <promise> tag"

jq -n \
  --arg prompt "$PROMPT" \
  --arg msg "$SYSTEM_MSG" \
  '{
    "decision": "block",
    "reason": $prompt,
    "systemMessage": $msg
  }'

exit 0
