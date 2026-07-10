---
name: vague
description: This skill should be used when the user's request or requirement is ambiguous and needs iterative questioning to become actionable. Trigger on "clarify requirements", "refine requirements", "요구사항 명확히", "요구사항 정리", "make this clearer", "spec this out", "scope this", "/clarify:vague". Turns vague inputs into concrete specs. For strategy blind spots use unknown; for content-vs-form reframing use metamedium.
user-invocable: true
argument-hint: [requirement]
---

# Vague: Requirement Clarification

Transform vague requirements into precise, actionable specifications through hypothesis-driven questioning.

## When to Use

- Ambiguous feature requests ("add a login feature")
- Incomplete bug reports ("the export is broken")
- Underspecified tasks ("make the app faster")

For strategy/planning blind spot analysis, use **unknown**. For content-vs-form reframing, use **metamedium**.

## Core Principle: Hypotheses as Options

Use **AskUserQuestion** for clarification. Do not ask open-ended free-text questions when options can represent plausible hypotheses.

- Bad: `What kind of login do you want?`
- Good: `OAuth / Email+Password / SSO / Magic link`

Each option should be a testable interpretation of user intent.

## Invocation

Parse input:
- **REQUIREMENT**: requirement text (required)
- **--max-iterations N**: max rounds (default: 3)

## Initialization

1. Create `.claude/clarify-vague.local.md` at the project root (the current working directory). The Stop hook resolves the same path from the hook `cwd`.

```markdown
---
iteration: 1
max_iterations: [MAX_ITERATIONS]
original_requirement: "[REQUIREMENT]"
started_at: "[ISO 8601 timestamp, e.g. 2026-07-10T14:30:00+09:00]"
---

## Original Requirement
"[REQUIREMENT]"

## Clarification Progress
(Decisions are appended as the loop progresses)
```

`started_at` is required: the Stop hook has no session id at skill time, so it binds the loop to the current session on its first fire (adds `session_id` itself) and uses `started_at` for a 2-hour TTL. Do not add `session_id` yourself.

2. Confirm activation:

```text
Vague clarification loop activated!

Original Requirement: "[REQUIREMENT]"
Max Iterations: [MAX_ITERATIONS]

Say "cancel" or "stop" anytime to end the loop.
```

## Protocol

### Phase 1: Diagnose Ambiguity

Capture unknowns across categories:
- Scope
- Behavior
- Data / Interface
- Constraints / Priority
- Success criteria

### Phase 2: Iterative Clarification

Use AskUserQuestion to resolve ambiguities. This section is the single source of
truth for how questions are shaped — the Stop hook only re-injects a pointer back
to these rules, it does not restate them.

Rules:
- Ask **only as many questions as there are material ambiguities**, up to a maximum of **4 per round**. Padding to a fixed count adds cognitive load without adding information.
- Give each question **2–4 options**, each a plausible hypothesis of the user's intent — no filler options to reach a fixed count.
- The **last question of each round** must offer a completion option: `Clarification complete - proceed with current understanding`.
- Batch the round's questions in a single AskUserQuestion call.
- Cap total rounds by `--max-iterations`.

### Phase 3: Completion Check

Stop when any condition is met:
- User selects the clarification-complete option
- User signals cancellation (see Cancellation below)
- Max iterations reached

### Cancellation

If the user signals they want to cancel or stop the loop (e.g. "cancel", "stop",
"그만", "중단"), delete `.claude/clarify-vague.local.md` and end the loop without a
summary.

### Phase 4: Before/After Summary

Output:

```markdown
## Requirement Clarification Summary

### Before (Original)
"{original requirement verbatim}"

### After (Clarified)
**Goal**: [precise description]
**Reason**: [why this matters]
**Scope**: [included and excluded]
**Constraints**: [limitations and preferences]
**Success Criteria**: [how completion is verified]

**Decisions Made**:
| Question | Decision |
|----------|----------|
| [ambiguity 1] | [selected option] |
```

Then output:

`<promise>CLARIFICATION COMPLETE</promise>`

Only output the promise when clarification is genuinely complete.

## Question Design Rules

1. Hypothesis options over open questions
2. Neutral framing (avoid leading choices)
3. One ambiguity axis per question
4. Preserve user intent (refine, do not redirect)
5. Keep language concrete and implementation-relevant

Now begin by creating the state file, identifying the material ambiguities (up to four), and asking the first AskUserQuestion batch.
