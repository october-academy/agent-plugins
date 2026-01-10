---
description: "Explain Clarify Ralph technique and available commands"
allowed-tools: []
---

# Clarify Ralph - Help

## What is Clarify Ralph?

Clarify Ralph is an iterative requirement clarification tool that transforms vague requirements into precise, actionable specifications through structured questioning.

It combines two techniques:
- **Clarify skill**: AskUserQuestion-based requirement refinement
- **Ralph Wiggum technique**: Stop hook for automatic iteration loops

## Commands

### /clarify-ralph

Start a clarification loop.

```bash
/clarify-ralph "<requirement>" --max-iterations <n>
```

**Arguments:**
- `<requirement>` - The vague requirement to clarify
- `--max-iterations <n>` - Maximum questions (default: 10)

**Examples:**
```bash
/clarify-ralph Add a login feature
/clarify-ralph Build a REST API --max-iterations 15
/clarify-ralph "Fix the export bug" --max-iterations 5
```

### /cancel-clarify

Cancel the active loop immediately.

```bash
/cancel-clarify
```

## How It Works

1. **Start**: Run `/clarify-ralph` with your vague requirement
2. **Questions**: Claude asks 4 clarifying questions at once, each with 4 options
3. **Answer**: You select options or provide custom input for each question
4. **Check**: The 4th question's 4th option is always "Clarification complete"
5. **Repeat**: Loop continues until completion or max iterations
6. **Output**: Final Before/After comparison of the requirement

## Completion Conditions

The loop ends when:
- You select "Clarification complete" option
- Max iterations reached
- You run `/cancel-clarify`

## Output Format

When complete, you get:

```markdown
## Requirement Clarification Summary

### Before (Original)
"Add a login feature"

### After (Clarified)
**Goal**: Add username/password login with self-registration
**Reason**: Restrict access to authorized users only
**Scope**: Login, logout, registration, password reset
**Constraints**: 24h session, bcrypt, rate limit 5 attempts
**Success Criteria**: User can register, login, logout, reset password

**Decisions Made**:
| Question | Decision |
|----------|----------|
| Authentication method? | Username/Password |
| Registration included? | Yes, self-signup |
| Session duration? | 24 hours |
```

## Ambiguity Categories

Questions probe these areas:

| Category | Focus |
|----------|-------|
| **Scope** | What's in/out? |
| **Behavior** | Edge cases, errors |
| **Interface** | Who/what interacts? |
| **Data** | Inputs, outputs, format |
| **Constraints** | Performance, compatibility |
| **Priority** | Must-have vs nice-to-have |
| **Reason** | Why? Jobs to be done |
| **Success** | How to verify? |

## Tips

- Start with vague requirements intentionally
- Don't pre-clarify before running the loop
- Let the structured questioning surface hidden assumptions
- Use "Other" option for nuanced answers
- Set appropriate `--max-iterations` based on complexity
