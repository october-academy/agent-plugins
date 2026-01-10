---
description: "Start iterative requirement clarification loop"
argument-hint: "REQUIREMENT [--max-iterations N]"
allowed-tools: ["Bash", "AskUserQuestion", "Write", "Read"]
hide-from-slash-command-tool: "true"
---

# Clarify Ralph Command

Initialize the clarification loop:

```!
set -euo pipefail

# Parse arguments
REQUIREMENT_PARTS=()
MAX_ITERATIONS=10
ARGS=($ARGUMENTS)

i=0
while [[ $i -lt ${#ARGS[@]} ]]; do
  case "${ARGS[$i]}" in
    -h|--help)
      cat << 'HELP_EOF'
Clarify Ralph - Iterative requirement clarification

USAGE:
  /clarify-ralph [REQUIREMENT...] [OPTIONS]

ARGUMENTS:
  REQUIREMENT...    The vague requirement to clarify (can be multiple words)

OPTIONS:
  --max-iterations <n>    Maximum questions before auto-stop (default: 10)
  -h, --help              Show this help message

EXAMPLES:
  /clarify-ralph Add a login feature
  /clarify-ralph Build a REST API --max-iterations 15
HELP_EOF
      exit 0
      ;;
    --max-iterations)
      ((i++))
      if [[ $i -ge ${#ARGS[@]} ]]; then
        echo "Error: --max-iterations requires a number" >&2
        exit 1
      fi
      MAX_ITERATIONS="${ARGS[$i]}"
      ;;
    *)
      REQUIREMENT_PARTS+=("${ARGS[$i]}")
      ;;
  esac
  ((i++))
done

REQUIREMENT="${REQUIREMENT_PARTS[*]}"

if [[ -z "$REQUIREMENT" ]]; then
  echo "Error: No requirement provided" >&2
  echo "Usage: /clarify-ralph <requirement> [--max-iterations N]" >&2
  exit 1
fi

mkdir -p .claude

cat > .claude/clarify-ralph.local.md <<EOF
---
active: true
iteration: 1
max_iterations: $MAX_ITERATIONS
original_requirement: "$REQUIREMENT"
started_at: "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
---

## Original Requirement
"$REQUIREMENT"

## Clarification Progress
(Decisions will be recorded as the loop progresses)

EOF

cat <<EOF
Clarify Ralph loop activated!

Original Requirement: "$REQUIREMENT"
Max Questions: $MAX_ITERATIONS

To cancel: /cancel-clarify

---

## Requirement to Clarify
"$REQUIREMENT"
EOF
```

You are now in a **Clarify Ralph Loop**. Your goal is to transform the vague requirement above into a precise, actionable specification through iterative questioning.

## Your Task

1. **Analyze** the original requirement for ambiguities
2. **Ask 4 questions** in a single `AskUserQuestion` call to resolve multiple ambiguities at once
3. **Record** all answers in your understanding
4. **Check completion**: Include "Clarification complete" as the last option of the last question
5. **Repeat** until user confirms completion OR max iterations reached

## Question Design Guidelines

- Ask **exactly 4 questions** per iteration (use all 4 question slots)
- Provide **exactly 4 options** per question (use all 4 option slots)
- The **4th question's 4th option** should be "Clarification complete - proceed with current understanding"
- Use **neutral framing** without bias toward any option
- Cover **different ambiguity categories** in each question set

## Ambiguity Categories to Probe

| Category | Example Questions |
|----------|------------------|
| **Scope** | What's included? What's explicitly out? |
| **Behavior** | Edge cases? Error scenarios? |
| **Interface** | Who/what interacts? How? |
| **Data** | Inputs? Outputs? Format? |
| **Constraints** | Performance? Compatibility? |
| **Priority** | Must-have vs nice-to-have? |
| **Reason** | Why? What's the jobs to be done? |
| **Success** | How to verify completion? |

## Completion Rules

When the user selects "Clarification complete" OR you reach max iterations:

1. Output the final clarified requirement in this format:

```markdown
## Requirement Clarification Summary

### Before (Original)
"{original requirement verbatim}"

### After (Clarified)
**Goal**: [precise description]
**Reason**: [the ultimate purpose]
**Scope**: [what's included and excluded]
**Constraints**: [limitations, requirements]
**Success Criteria**: [how to verify]

**Decisions Made**:
| Question | Decision |
|----------|----------|
| [ambiguity 1] | [chosen option] |
| [ambiguity 2] | [chosen option] |
```

2. Then output: `<promise>CLARIFICATION COMPLETE</promise>`

**CRITICAL**: Only output the promise when you have genuinely finished clarification. Do NOT lie to exit the loop.

---

Now begin by identifying 4 key ambiguities and asking 4 clarifying questions (each with 4 options) using a single AskUserQuestion call.
