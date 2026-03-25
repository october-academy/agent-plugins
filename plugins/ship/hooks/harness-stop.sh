#!/bin/bash
# Harness Stop Hook
# 세션 종료 시 구조화된 상태를 보존하고 재개 가능한 handoff를 생성

HARNESS_DIR=".harness"
STATE_FILE="$HARNESS_DIR/state.json"

if [ -d "$HARNESS_DIR" ]; then
  if [ -f "$STATE_FILE" ]; then
    # state.json에서 현재 상태 읽기
    PHASE=$(python3 -c "import json; print(json.load(open('$STATE_FILE'))['phase'])" 2>/dev/null || echo "unknown")
    SPRINT=$(python3 -c "import json; print(json.load(open('$STATE_FILE'))['current_sprint'])" 2>/dev/null || echo "?")
    TOTAL=$(python3 -c "import json; print(json.load(open('$STATE_FILE'))['total_sprints'])" 2>/dev/null || echo "?")

    echo "harness: phase=$PHASE, sprint=$SPRINT/$TOTAL"
    echo "hint: /ship 로 재개 — state.json에서 중단 지점 자동 감지"

    # handoff 파일 생성
    HANDOFF="$HARNESS_DIR/handoff.md"
    cat > "$HANDOFF" << EOF
## Harness Session Handoff

- **Phase**: $PHASE
- **Sprint**: $SPRINT / $TOTAL
- **Timestamp**: $(date -u +%Y-%m-%dT%H:%M:%SZ)

### Resume Instructions
1. Read .harness/state.json for machine-readable state
2. Read .harness/spec.md for product spec
3. Check current sprint directory for latest artifacts
4. Continue from phase: $PHASE
EOF
  else
    # state.json 없이 디렉토리만 존재하는 경우
    LATEST_SPRINT=$(ls -d "$HARNESS_DIR"/sprints/sprint-* 2>/dev/null | sort -V | tail -1)
    if [ -n "$LATEST_SPRINT" ]; then
      echo "harness: $(basename $LATEST_SPRINT) — state.json 없음 (초기 상태)"
    fi
    echo "hint: /ship 로 재개 가능"
  fi
fi
