---
name: interview
description: This skill should be used when the user's request or requirement is ambiguous and needs an iterative interview to become actionable — vague feature requests ("add notifications"), incomplete bug reports ("the export is broken"), underspecified tasks and migrations ("make it faster", "convert this to TypeScript"), or any build request the user hasn't fully thought through. Trigger on "clarify requirements", "refine requirements", "요구사항 명확히", "요구사항 정리", "요구사항 인터뷰", "인터뷰해줘", "interview me", "ask me questions before building", "make this clearer", "spec this out", "scope this", "/clarify:interview". Turns vague inputs into concrete specs and surfaces considerations the user hasn't thought of. For strategy blind spots use unknown; for content-vs-form reframing use metamedium.
user-invocable: true
argument-hint: [requirement]
---

# Interview: Requirement Clarification

Turn a vague request into a spec the user actually wants built, through a hypothesis-driven interview.

The request the user gives is a map; the codebase and its real constraints are the territory. Every gap between them is an unknown that would otherwise get filled with a guess. Instructions that are too specific get followed even when a pivot is better; instructions that are too vague get patched with industry defaults that may not fit. The interview escapes both failure modes: instead of guessing, put the decision points in front of the user — including the ones they never thought to raise. A few minutes of questions is the cheapest way to find out what nobody knew, before it gets expensive to fix.

## When to Use

- Ambiguous feature requests ("add a login feature")
- Incomplete bug reports ("the export is broken")
- Underspecified tasks ("make the app faster")

For strategy/planning blind spot analysis, use **unknown**. For content-vs-form reframing, use **metamedium**. If the user's uncertainty is "I'll know it when I see it" (visual/design taste), offer 2-3 quick prototypes or variants instead of more questions — interviews resolve ambiguities that words can settle.

## Invocation

Parse input:
- **REQUIREMENT**: requirement text (required)
- **--max-iterations N**: max question rounds (default: 3)

## Initialization

1. Create `.claude/clarify-interview.local.md` at the project root (the current working directory). The Stop hook resolves the same path from the hook `cwd`.

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
(Append one block per round — see Interview Rounds step 4)
```

`started_at` is required: the Stop hook has no session id at skill time, so it binds the loop to the current session on its first fire (adds `session_id` itself) and uses `started_at` for a 2-hour TTL. Do not add `session_id` yourself.

2. Confirm activation:

```text
Interview clarification loop activated!

Original Requirement: "[REQUIREMENT]"
Max Iterations: [MAX_ITERATIONS]

Say "cancel" or "stop" anytime to end the loop.
```

## Protocol

### Phase 1: Walk the Territory

Before designing any question, spend a few minutes in the actual project: the files the request touches, recent related changes, README/config that constrains the answer. Two reasons:

- Asking the user something the codebase already answers wastes their attention and your question budget.
- Questions grounded in what you found ("this route was rewritten last month — broken since then?") get far better answers than template questions.

If there is no project context (greenfield conversation), skip the sweep and ground questions in the request's own domain instead.

### Phase 2: Diagnose Ambiguity

List candidate unknowns across: scope, behavior, data/interface, constraints/priority, success criteria. An ambiguity is **material** when different plausible answers lead to different implementations — if every answer lands in the same code, don't ask.

Then look past the user's own framing: what has this user *not considered at all*? Failure and abuse paths, volume/rate extremes, lifecycle after the happy path (what happens after the third retry fails?), who else is affected. Plan at least one question or option per interview that surfaces such a blind spot — the mark of a good interview is the user saying "oh right, that too." If the territory suggests the request itself may be solving the wrong problem, raise that as a question, not a silent redirect.

### Phase 3: Interview Rounds

Use **AskUserQuestion**. This section is the single source of truth for question shaping — the Stop hook only re-injects a pointer back here, it does not restate the rules.

Runtime note: AskUserQuestion is the Claude Code tool name. On Codex, use `request_user_input` with the same batched questions and options. If no structured-question tool exists, present the same options as a numbered plain-text list and wait for the reply — every rule below applies unchanged.

1. **Prioritize by leverage.** Lead with questions whose answers change the architecture or scope (who is it for, what triggers it, what's in/out); leave wording/naming details out entirely.
2. **Shape each question:** 2–4 options, each a plausible hypothesis of intent that would genuinely change what gets built; one ambiguity axis per question; neutral framing (don't make one option "obviously right" by wording); concrete, implementation-relevant language, in the conversation's language.
   - Bad: `What kind of login do you want?`
   - Good: `OAuth / Email+Password / SSO / Magic link`
   - For requests that change an existing system (migrate, convert, adopt, rewrite): include adoption strategy among the hypotheses — incremental, big-bang, tooling/check-only — not just end-state variants. End-state-only options force users to smuggle "gradually, please" through Other.
   - When you have a sensible default, put it first labeled `(Recommended)`. Use `multiSelect: true` when choices aren't mutually exclusive.
3. **Batch independent questions** — up to 4 per round, one AskUserQuestion call. If a question's options depend on another question's answer, defer it to the next round: options designed blind degrade into guesses.
4. **After each round, append the outcomes to the state file** under `## Clarification Progress`. Keep `iteration` equal to the round you are currently asking — bump it as you start a round, not after the last one. Sessions get compacted and interrupted; the state file is what lets the loop resume without re-asking.

```markdown
### Round N
- [axis]: [outcome] — decided | assumed (recommended default) | still open
```

5. **Handle "I don't know" / free-text answers:** when the user defers ("잘 모르겠어요, 추천해주세요"), adopt your recommended option and record it as **assumed**, not decided. A custom "Other" answer is an explicit user statement — record it as decided; it usually opens a fresh hypothesis, so follow up next round only if material. When the answer defers to an absent authority ("그건 대표님이 정하셔야 해요"), the requester is a proxy: record your recommended default as **assumed — pending [owner]'s confirmation**, or put the item in Still Open naming the owner and how it gets resolved. Never present it as decided.
   - Greenfield caveat: if the project is empty but the request implies an existing system elsewhere, ask where this will integrate — an unknown integration point blocks the build, so it belongs in the interview, not in Still Open.
6. **Offer an exit honestly.** When remaining ambiguities are optional depth, add a final option meaning "clarification complete — proceed with current understanding" (wording localized, e.g. `여기까지 — 현재 이해로 진행`) to the round's last question — or as its own question in the same round when that question needs all its option slots for real hypotheses. When material ambiguities clearly remain, don't offer a premature exit; when none remain, don't ask another round at all — summarize.

### Phase 4: Completion Check

Summarize when any of these holds:

- No material ambiguity remains (your judgment — the common case)
- User selects the clarification-complete option
- User signals cancellation (see Cancellation)
- Final round's answers are in and `max_iterations` is reached

Hitting `max_iterations` with material axes still unasked is triage, not completion: spend the final round on correctness-critical axes first, and record each unasked axis as an assumption explicitly labeled un-asked (e.g. `미질문 — 라운드 예산 소진`) — never as something the user delegated.

### Cancellation

If the user signals they want to cancel or stop the loop (e.g. "cancel", "stop", "그만", "중단"), delete `.claude/clarify-interview.local.md` and end the loop without a summary.

### Phase 5: Before/After Summary

Every line of the After spec must trace to a user answer, a fact you verified in the territory, or a listed assumption — a spec line with no source is fabrication. Before emitting the promise, audit the After spec claim by claim — parentheticals included (volumes, thresholds, counts, quotes) — and name each claim's source to yourself; anything sourceless gets rewritten as an assumption or dropped. Context can carry facts nobody said (an earlier plan, a pasted doc, your own hypothesis options); the audit is what keeps them out of the spec.

```markdown
## Requirement Clarification Summary

### Before (Original)
"{original requirement verbatim}"

### After (Clarified)
**Goal**: [precise description]
**Reason**: [why this matters]
**Scope**: [included and excluded]
**Constraints**: [limitations and preferences]
**Success Criteria**: [how completion is verified — push for a measurable threshold]

**Decisions Made** (user-selected):
| Question | Decision |
|----------|----------|

**Assumptions** (recommended defaults the user deferred — flag before building on them; omit if none):
| Topic | Assumed |
|-------|---------|

**Surfaced Along the Way**: [considerations the user hadn't raised, now decided or assumed — omit if none]

**Still Open**: [residual unknowns + how each gets resolved (experiment, measurement, later decision) — omit if none]
```

The user should leave with a better map, not just answered questions — the last two sections are where the interview pays for itself.

Write all content (activation message, questions, summary values) in the conversation's language; keep the structural headings and the promise tag verbatim so hooks and tooling can parse them.

Then output:

`<promise>CLARIFICATION COMPLETE</promise>`

Only output the promise when clarification is genuinely complete. After emitting it, delete `.claude/clarify-interview.local.md` yourself — the Stop hook also cleans it up when present, but hookless runtimes would otherwise leak the file.

## Loop Mechanics

AskUserQuestion returns answers mid-turn, so all rounds normally happen inside one turn and end with the summary + promise. The Stop hook is the safety net, not the driver: if a turn ends without the promise tag, it re-injects the loop (re-read `## Clarification Progress` first, then ask only what's still open), enforces `max_iterations` and the 2h TTL, and deletes the state file when it sees the promise. You own `iteration` while interviewing (step 4 above); the hook bumps it only on re-entry after an interrupted turn.

Now begin: create the state file, walk the territory, identify the material ambiguities and at least one blind-spot probe, and ask the first batch.
