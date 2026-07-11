#!/bin/bash

# Integration tests for stop-hook.sh.
#
# Simulates the Stop-hook JSON of both supported runtimes:
#   - Codex:       last_assistant_message inline in the hook input
#   - Claude Code: transcript_path pointing at a JSONL transcript
# and asserts the full state machine: re-injection loop, terminal promises
# (COMPLETE/CAPPED), the plain-text awaiting_user free pass, the once-only
# cap summary request, and the cleanup paths (corruption, TTL, session
# mismatch, transient transcript conditions).
#
# Run: bash plugins/clarify/hooks/test-stop-hook.sh

set -uo pipefail

HOOK="$(cd "$(dirname "$0")" && pwd)/stop-hook.sh"
PASS=0
FAIL=0
CURRENT=""

fail() {
  echo "FAIL [$CURRENT] $1"
  FAIL=$((FAIL + 1))
}

ok() {
  PASS=$((PASS + 1))
}

# fresh_env: new sandbox cwd with a .claude/ dir; sets WORK/STATE globals.
fresh_env() {
  WORK=$(mktemp -d)
  mkdir -p "$WORK/.claude"
  STATE="$WORK/.claude/clarify-interview.local.md"
}

# write_state <iteration> <max> [extra frontmatter lines...]
write_state() {
  local iter="$1" max="$2"
  shift 2
  {
    echo '---'
    echo "iteration: $iter"
    echo "max_iterations: $max"
    echo 'original_requirement: "재고 부족 알림"'
    echo "started_at: \"$(date -u +%Y-%m-%dT%H:%M:%S+0000)\""
    for line in "$@"; do echo "$line"; done
    echo '---'
    echo
    echo '## Clarification Progress'
    echo '- R1: 데이터 소스 질문 완료'
  } > "$STATE"
}

# codex_input <last_assistant_message>
codex_input() {
  jq -n --arg cwd "$WORK" --arg msg "$1" \
    '{session_id: "sess-1", cwd: $cwd, last_assistant_message: $msg}'
}

# claude_input [transcript_path]
claude_input() {
  jq -n --arg cwd "$WORK" --arg tp "${1:-}" \
    '{session_id: "sess-1", cwd: $cwd} + (if $tp == "" then {} else {transcript_path: $tp} end)'
}

# write_transcript <assistant text>
write_transcript() {
  TRANSCRIPT="$WORK/transcript.jsonl"
  jq -nc --arg t "$1" \
    '{type: "assistant", message: {role: "assistant", content: [{type: "text", text: $t}]}}' \
    > "$TRANSCRIPT"
}

# run_hook <input json> -> RC, OUT
run_hook() {
  OUT=$(printf '%s' "$1" | bash "$HOOK" 2>/dev/null)
  RC=$?
}

state_field() {
  sed -n '/^---$/,/^---$/p' "$STATE" | grep "^$1:" | head -1 | sed "s/^$1: *//; s/^\"\(.*\)\"\$/\1/"
}

# ---------------------------------------------------------------------------

CURRENT="T1 no state file -> allow exit"
fresh_env
run_hook "$(codex_input '아무 텍스트')"
[[ $RC -eq 0 ]] || fail "expected exit 0, got $RC"
[[ -z "$OUT" ]] || fail "expected no output, got: $OUT"
ok

CURRENT="T2 Codex promise-less turn -> decision:block + iteration increment"
fresh_env
write_state 1 5
run_hook "$(codex_input '아직 질문이 남았습니다')"
echo "$OUT" | jq -e '.decision == "block"' >/dev/null || fail "expected decision:block, got: $OUT"
echo "$OUT" | jq -e '.reason | contains("iteration 2/5")' >/dev/null || fail "expected iteration 2/5 in reason"
[[ "$(state_field iteration)" == "2" ]] || fail "expected iteration incremented to 2"
ok

CURRENT="T3 Claude Code transcript promise-less turn -> decision:block"
fresh_env
write_state 2 5
write_transcript '다음 질문을 준비 중입니다'
run_hook "$(claude_input "$TRANSCRIPT")"
echo "$OUT" | jq -e '.decision == "block"' >/dev/null || fail "expected decision:block, got: $OUT"
[[ "$(state_field iteration)" == "3" ]] || fail "expected iteration incremented to 3"
ok

CURRENT="T4 COMPLETE promise -> cleanup"
fresh_env
write_state 3 5
run_hook "$(codex_input '요약 완료 <promise>CLARIFICATION COMPLETE</promise>')"
[[ $RC -eq 0 ]] || fail "expected exit 0, got $RC"
[[ ! -f "$STATE" ]] || fail "expected state file removed"
ok

CURRENT="T5 CAPPED promise -> cleanup"
fresh_env
write_state 5 5
run_hook "$(codex_input '요약 완료 <promise>CLARIFICATION CAPPED</promise>')"
[[ $RC -eq 0 ]] || fail "expected exit 0, got $RC"
[[ ! -f "$STATE" ]] || fail "expected state file removed"
ok

CURRENT="T6 awaiting_user free pass -> yield to user, state preserved, flag flipped"
fresh_env
write_state 2 5 'awaiting_user: "true"'
run_hook "$(codex_input '1) 옵션 A / 2) 옵션 B / 3) 기타: 직접 설명')"
[[ $RC -eq 0 ]] || fail "expected exit 0, got $RC"
[[ -z "$OUT" ]] || fail "expected no block JSON, got: $OUT"
[[ -f "$STATE" ]] || fail "expected state file preserved"
[[ "$(state_field awaiting_user)" == "false" ]] || fail "expected awaiting_user flipped to false"
[[ "$(state_field iteration)" == "2" ]] || fail "expected iteration unchanged on free pass"
ok

CURRENT="T7 free pass is once-only -> next promise-less stop blocks again"
# Reuses T6's post-pass state (awaiting_user already flipped to "false").
run_hook "$(codex_input '추가 설명 없이 턴 종료')"
echo "$OUT" | jq -e '.decision == "block"' >/dev/null || fail "expected decision:block after used pass, got: $OUT"
[[ "$(state_field iteration)" == "3" ]] || fail "expected iteration incremented to 3"
ok

CURRENT="T8 cap reached without promise -> once-only decision:block summary request"
fresh_env
write_state 5 5
run_hook "$(codex_input '캡에 도달했지만 promise 없이 종료 시도')"
echo "$OUT" | jq -e '.decision == "block"' >/dev/null || fail "expected decision:block, got: $OUT"
echo "$OUT" | jq -e '.reason | contains("CLARIFICATION CAPPED")' >/dev/null || fail "expected CAPPED instruction in reason"
[[ -f "$STATE" ]] || fail "expected state file preserved for the summary turn"
[[ "$(state_field cap_summary_requested)" == "true" ]] || fail "expected cap_summary_requested marker set"
ok

CURRENT="T9 cap summary already requested, still no promise -> cleanup"
# Reuses T8's post-request state (cap_summary_requested: "true").
run_hook "$(codex_input '여전히 promise 없는 출력')"
[[ $RC -eq 0 ]] || fail "expected exit 0, got $RC"
[[ -z "$OUT" ]] || fail "expected no second block, got: $OUT"
[[ ! -f "$STATE" ]] || fail "expected state file removed after burned marker"
ok

CURRENT="T10 session mismatch -> cleanup without re-injection"
fresh_env
write_state 1 5 'session_id: "sess-OTHER"'
run_hook "$(codex_input '아직 진행 중')"
[[ $RC -eq 0 ]] || fail "expected exit 0, got $RC"
[[ -z "$OUT" ]] || fail "expected no block JSON, got: $OUT"
[[ ! -f "$STATE" ]] || fail "expected state file removed on mismatch"
ok

CURRENT="T11 corrupted iteration -> cleanup"
fresh_env
write_state banana 5
run_hook "$(codex_input '아직 진행 중')"
[[ $RC -eq 0 ]] || fail "expected exit 0, got $RC"
[[ ! -f "$STATE" ]] || fail "expected corrupted state file removed"
ok

CURRENT="T12 TTL expired -> cleanup without re-injection"
fresh_env
write_state 1 5
sed 's/^started_at: .*/started_at: "2020-01-01T00:00:00+0000"/' "$STATE" > "$STATE.tmp" \
  && mv "$STATE.tmp" "$STATE"
run_hook "$(codex_input '아직 진행 중')"
[[ $RC -eq 0 ]] || fail "expected exit 0, got $RC"
[[ -z "$OUT" ]] || fail "expected no block JSON, got: $OUT"
[[ ! -f "$STATE" ]] || fail "expected expired state file removed"
ok

CURRENT="T13 Claude Code transcript missing -> transient, state preserved"
fresh_env
write_state 2 5
run_hook "$(claude_input "$WORK/does-not-exist.jsonl")"
[[ $RC -eq 0 ]] || fail "expected exit 0, got $RC"
[[ -z "$OUT" ]] || fail "expected no block JSON, got: $OUT"
[[ -f "$STATE" ]] || fail "expected state preserved on transient condition"
[[ "$(state_field iteration)" == "2" ]] || fail "expected iteration unchanged"
ok

CURRENT="T14 terminal promise wins over awaiting_user -> cleanup"
fresh_env
write_state 3 5 'awaiting_user: "true"'
run_hook "$(codex_input '최종 요약 <promise>CLARIFICATION CAPPED</promise>')"
[[ $RC -eq 0 ]] || fail "expected exit 0, got $RC"
[[ ! -f "$STATE" ]] || fail "expected state removed (promise checked before awaiting_user)"
ok

CURRENT="T15 COMPLETE at consumed cap -> rejected once, CAPPED requested"
fresh_env
write_state 5 5
run_hook "$(codex_input '요약 완료 <promise>CLARIFICATION COMPLETE</promise>')"
echo "$OUT" | jq -e '.decision == "block"' >/dev/null || fail "expected decision:block, got: $OUT"
echo "$OUT" | jq -e '.reason | contains("CLARIFICATION CAPPED")' >/dev/null || fail "expected CAPPED re-emit request"
[[ -f "$STATE" ]] || fail "expected state preserved for the re-emit turn"
[[ "$(state_field cap_complete_rejected)" == "true" ]] || fail "expected cap_complete_rejected marker set"
ok

CURRENT="T16 second COMPLETE after rejection -> fail closed (retraction requested, never success)"
# Reuses T15's post-rejection state (cap_complete_rejected: "true").
run_hook "$(codex_input '재발화 요약 <promise>CLARIFICATION COMPLETE</promise>')"
echo "$OUT" | jq -e '.decision == "block"' >/dev/null || fail "expected retraction block, got: $OUT"
echo "$OUT" | jq -e '.reason | contains("CAPPED")' >/dev/null || fail "expected CAPPED correction in reason"
echo "$OUT" | jq -e '.systemMessage | contains("violation")' >/dev/null || fail "expected violation-labeled systemMessage"
[[ ! -f "$STATE" ]] || fail "expected loop state cleared (no further re-injection)"
# The correction turn (no promise, no state file) must then end cleanly.
run_hook "$(codex_input '정정: 이 요약은 CAPPED로 읽어야 합니다')"
[[ $RC -eq 0 ]] || fail "expected exit 0 on correction turn, got $RC"
[[ -z "$OUT" ]] || fail "expected no further block after state cleared, got: $OUT"
ok

CURRENT="T17 COMPLETE below cap -> accepted directly (budget to spare)"
fresh_env
write_state 2 5
run_hook "$(codex_input '요약 완료 <promise>CLARIFICATION COMPLETE</promise>')"
[[ $RC -eq 0 ]] || fail "expected exit 0, got $RC"
[[ -z "$OUT" || "$OUT" != *'"block"'* ]] || fail "expected no rejection below cap, got: $OUT"
[[ ! -f "$STATE" ]] || fail "expected state removed"
ok

CURRENT="T18 awaiting_user without numbered questions -> flag burned, loop resumes"
fresh_env
write_state 2 5 'awaiting_user: "true"'
run_hook "$(codex_input '질문 없이 생각만 정리하고 턴을 끝냅니다')"
echo "$OUT" | jq -e '.decision == "block"' >/dev/null || fail "expected re-injection block, got: $OUT"
[[ "$(state_field awaiting_user)" == "false" ]] || fail "expected flag burned to false"
ok

CURRENT="T19 awaiting_user with numbered NON-question -> no false pass, loop resumes"
fresh_env
write_state 2 5 'awaiting_user: "true"'
run_hook "$(codex_input '1) 진행 상황 정리')"
echo "$OUT" | jq -e '.decision == "block"' >/dev/null || fail "expected re-injection block for numbered non-question, got: $OUT"
[[ "$(state_field awaiting_user)" == "false" ]] || fail "expected flag burned to false"
ok

CURRENT="T20 awaiting_user with a real option batch -> yields (question signal + >=2 options)"
fresh_env
write_state 2 5 'awaiting_user: "true"'
run_hook "$(codex_input '어떤 방식이 좋을까요?
1) 옵션 A — 설명
2) 옵션 B — 설명
3) 기타: 직접 설명')"
[[ $RC -eq 0 ]] || fail "expected exit 0, got $RC"
[[ -z "$OUT" ]] || fail "expected yield with no block, got: $OUT"
[[ -f "$STATE" ]] || fail "expected state preserved"
ok

# write_guard_file <iteration> <max> [session] [epoch|-]
# epoch defaults to now; a literal '-' writes a malformed 3-field guard.
write_guard_file() {
  local epoch="${4:-$(date +%s)}"
  if [[ "$epoch" == "-" ]]; then
    printf '%s %s %s\n' "$1" "$2" "${3:-sess-1}" > "$WORK/.claude/clarify-interview.guard"
  else
    printf '%s %s %s %s\n' "$1" "$2" "${3:-sess-1}" "$epoch" > "$WORK/.claude/clarify-interview.guard"
  fi
}
GUARD_PATH() { printf '%s' "$WORK/.claude/clarify-interview.guard"; }

CURRENT="T21 self-deleted state + COMPLETE at consumed cap -> guard fails closed"
fresh_env
write_guard_file 3 3
run_hook "$(codex_input '요약 완료 <promise>CLARIFICATION COMPLETE</promise>')"
echo "$OUT" | jq -e '.decision == "block"' >/dev/null || fail "expected retraction block, got: $OUT"
echo "$OUT" | jq -e '.reason | contains("CAPPED")' >/dev/null || fail "expected CAPPED correction"
[[ ! -f "$(GUARD_PATH)" ]] || fail "expected guard consumed"
ok

CURRENT="T22 self-deleted state + CAPPED -> clean exit, guard consumed"
fresh_env
write_guard_file 3 3
run_hook "$(codex_input '요약 완료 <promise>CLARIFICATION CAPPED</promise>')"
[[ $RC -eq 0 ]] || fail "expected exit 0, got $RC"
[[ -z "$OUT" ]] || fail "expected no block, got: $OUT"
[[ ! -f "$(GUARD_PATH)" ]] || fail "expected guard consumed"
ok

CURRENT="T23 stale guard from another session -> ignored"
fresh_env
write_guard_file 3 3 sess-OTHER
run_hook "$(codex_input '요약 완료 <promise>CLARIFICATION COMPLETE</promise>')"
[[ $RC -eq 0 ]] || fail "expected exit 0, got $RC"
[[ -z "$OUT" ]] || fail "expected no block for foreign guard, got: $OUT"
ok

CURRENT="T24 self-deleted state + COMPLETE below cap -> legitimate, no retraction"
fresh_env
write_guard_file 2 5
run_hook "$(codex_input '요약 완료 <promise>CLARIFICATION COMPLETE</promise>')"
[[ $RC -eq 0 ]] || fail "expected exit 0, got $RC"
[[ -z "$OUT" ]] || fail "expected no block below cap, got: $OUT"
ok

CURRENT="T25 end-to-end bypass regression: cap block writes guard, then self-delete + COMPLETE is caught"
fresh_env
write_state 5 5
run_hook "$(codex_input '캡 도달, promise 없는 턴')"
echo "$OUT" | jq -e '.decision == "block"' >/dev/null || fail "expected cap summary block, got: $OUT"
[[ -f "$(GUARD_PATH)" ]] || fail "expected hook to have written the guard"
rm -f "$STATE"   # the model disobeys and deletes the state before its summary turn ends
run_hook "$(codex_input '요약 <promise>CLARIFICATION COMPLETE</promise>')"
echo "$OUT" | jq -e '.decision == "block"' >/dev/null || fail "expected fail-closed retraction, got: $OUT"
echo "$OUT" | jq -e '.systemMessage | contains("violation")' >/dev/null || fail "expected violation systemMessage"
ok

CURRENT="T26 first uninterrupted turn: skill-created guard (session '_') catches self-delete + COMPLETE at cap"
fresh_env
write_guard_file 3 3 _   # created at activation per SKILL Initialization step 2, updated per round
run_hook "$(codex_input '한 턴 안에서 라운드 소진 후 요약 <promise>CLARIFICATION COMPLETE</promise>')"
echo "$OUT" | jq -e '.decision == "block"' >/dev/null || fail "expected retraction with skill-written guard, got: $OUT"
[[ ! -f "$(GUARD_PATH)" ]] || fail "expected guard consumed"
ok

CURRENT="T27 guard iteration is monotonic: a hook snapshot never lowers a higher skill-written value"
fresh_env
write_state 2 5
write_guard_file 5 5   # skill progressed in-turn and mirrored 5; hook must not roll back
run_hook "$(codex_input '아직 진행 중')"
echo "$OUT" | jq -e '.decision == "block"' >/dev/null || fail "expected re-injection block, got: $OUT"
[[ "$(head -1 "$(GUARD_PATH)" | awk '{print $1}')" == "5" ]] || fail "expected guard iteration kept at 5, got: $(head -1 "$(GUARD_PATH)")"
ok

CURRENT="T28 transient transcript preserves the guard; next readable Stop still catches COMPLETE at cap"
fresh_env
write_guard_file 3 3
run_hook "$(claude_input "$WORK/missing-transcript.jsonl")"
[[ $RC -eq 0 ]] || fail "expected exit 0 on transient, got $RC"
[[ -f "$(GUARD_PATH)" ]] || fail "expected guard preserved on transient output"
write_transcript '요약 <promise>CLARIFICATION COMPLETE</promise>'
run_hook "$(claude_input "$TRANSCRIPT")"
echo "$OUT" | jq -e '.decision == "block"' >/dev/null || fail "expected retraction on the readable Stop, got: $OUT"
[[ ! -f "$(GUARD_PATH)" ]] || fail "expected guard consumed after judgment"
ok

CURRENT="T29 readable NON-terminal Stop preserves + binds the guard; the later COMPLETE is still caught"
fresh_env
SEED_EPOCH=$(date +%s)
write_guard_file 3 3 _ "$SEED_EPOCH"
run_hook "$(codex_input '중간 정리만 하고 태그 없이 턴 종료')"
[[ $RC -eq 0 ]] || fail "expected exit 0, got $RC"
[[ -f "$(GUARD_PATH)" ]] || fail "expected guard preserved on tag-less readable output"
[[ "$(head -1 "$(GUARD_PATH)" | awk '{print $3}')" == "sess-1" ]] || fail "expected wildcard guard bound to session, got: $(head -1 "$(GUARD_PATH)")"
[[ "$(head -1 "$(GUARD_PATH)" | awk '{print $4}')" == "$SEED_EPOCH" ]] || fail "expected creation epoch PRESERVED on rebind, got: $(head -1 "$(GUARD_PATH)")"
run_hook "$(codex_input '요약 <promise>CLARIFICATION COMPLETE</promise>')"
echo "$OUT" | jq -e '.decision == "block"' >/dev/null || fail "expected retraction after laundering attempt, got: $OUT"
ok

CURRENT="T30 mixed COMPLETE+CAPPED at consumed cap -> COMPLETE rejection wins (fail-closed path)"
fresh_env
write_state 5 5
run_hook "$(codex_input '요약 <promise>CLARIFICATION CAPPED</promise> ... <promise>CLARIFICATION COMPLETE</promise>')"
echo "$OUT" | jq -e '.decision == "block"' >/dev/null || fail "expected rejection block, got: $OUT"
[[ "$(state_field cap_complete_rejected)" == "true" ]] || fail "expected cap_complete_rejected marker"
[[ -f "$STATE" ]] || fail "expected state preserved for the re-emit"
ok

CURRENT="T31 mixed tags below cap -> once-only re-emit request, then EXPLICIT conservative correction"
fresh_env
write_state 2 5
run_hook "$(codex_input '요약 <promise>CLARIFICATION COMPLETE</promise> <promise>CLARIFICATION CAPPED</promise>')"
echo "$OUT" | jq -e '.decision == "block"' >/dev/null || fail "expected ambiguity block, got: $OUT"
echo "$OUT" | jq -e '.reason | contains("exactly one")' >/dev/null || fail "expected single-tag instruction"
[[ "$(state_field tag_ambiguity_rejected)" == "true" ]] || fail "expected ambiguity marker"
run_hook "$(codex_input '여전히 <promise>CLARIFICATION COMPLETE</promise> <promise>CLARIFICATION CAPPED</promise>')"
echo "$OUT" | jq -e '.decision == "block"' >/dev/null || fail "expected explicit correction block (never silent close), got: $OUT"
echo "$OUT" | jq -e '.reason | contains("CAPPED")' >/dev/null || fail "expected conservative CAPPED correction"
[[ ! -f "$STATE" ]] || fail "expected loop state cleared"
# The correction turn then ends cleanly.
run_hook "$(codex_input '정정: 이 요약은 CAPPED로 읽어야 합니다')"
[[ -z "$OUT" ]] || fail "expected no further block after correction, got: $OUT"
ok

CURRENT="T32 guard TTL expired (creation-anchored) -> discarded, no retraction"
fresh_env
write_guard_file 3 3 sess-1 1000000000
run_hook "$(codex_input '요약 <promise>CLARIFICATION COMPLETE</promise>')"
[[ $RC -eq 0 ]] || fail "expected exit 0, got $RC"
[[ -z "$OUT" ]] || fail "expected expired guard ignored, got: $OUT"
[[ ! -f "$(GUARD_PATH)" ]] || fail "expected expired guard removed"
ok

CURRENT="T33 epoch-less guard is malformed -> rejected loudly, never adopted"
fresh_env
write_guard_file 3 3 sess-1 -
run_hook "$(codex_input '요약 <promise>CLARIFICATION COMPLETE</promise>')"
[[ $RC -eq 0 ]] || fail "expected exit 0, got $RC"
[[ -z "$OUT" ]] || fail "expected malformed guard rejected without block, got: $OUT"
[[ ! -f "$(GUARD_PATH)" ]] || fail "expected malformed guard removed"
ok

CURRENT="T35 hook-side guard update preserves the creation epoch (TTL never extended)"
fresh_env
OLD_EPOCH=$(( $(date +%s) - 3600 ))   # 1h old — inside TTL, must survive untouched
write_state 2 5
write_guard_file 2 5 sess-1 "$OLD_EPOCH"
run_hook "$(codex_input '아직 진행 중')"
echo "$OUT" | jq -e '.decision == "block"' >/dev/null || fail "expected re-injection block, got: $OUT"
[[ "$(head -1 "$(GUARD_PATH)" | awk '{print $4}')" == "$OLD_EPOCH" ]] || fail "expected creation epoch preserved byte-for-byte, got: $(head -1 "$(GUARD_PATH)")"
ok

CURRENT="T34 guard-path mixed tags below cap -> re-emit request once, then explicit correction"
fresh_env
write_guard_file 2 5
run_hook "$(codex_input '요약 <promise>CLARIFICATION COMPLETE</promise> <promise>CLARIFICATION CAPPED</promise>')"
echo "$OUT" | jq -e '.decision == "block"' >/dev/null || fail "expected guard-path ambiguity block, got: $OUT"
echo "$OUT" | jq -e '.reason | contains("exactly one")' >/dev/null || fail "expected single-tag instruction"
[[ "$(head -1 "$(GUARD_PATH)" | awk '{print $5}')" == "ambig" ]] || fail "expected guard marked ambig, got: $(head -1 "$(GUARD_PATH)")"
run_hook "$(codex_input '여전히 <promise>CLARIFICATION CAPPED</promise> <promise>CLARIFICATION CAPPED</promise>')"
echo "$OUT" | jq -e '.decision == "block"' >/dev/null || fail "expected explicit correction on repeat, got: $OUT"
[[ ! -f "$(GUARD_PATH)" ]] || fail "expected guard consumed after correction"
ok

# ---------------------------------------------------------------------------

echo
echo "stop-hook integration tests: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]]
