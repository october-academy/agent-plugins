# Clarify

Transform vague requirements into precise, actionable specifications through structured questioning.

## Installation

```bash
# 1. Add marketplace (first time only)
claude plugin marketplace add october-academy/agent-plugins

# 2. Update marketplace
claude plugin marketplace update

# 3. Install plugin
claude plugin install clarify@agent-plugins

# 4. Restart Claude Code
```

## Usage

```bash
/clarify "Add a login feature"
/clarify "Build a REST API" --max-iterations 5
```

## How It Works

```
┌─────────────────────────────────────────────────────┐
│  /clarify "Add a login feature"                     │
└──────────────────────┬──────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────┐
│  Iteration 1: Claude asks 4 clarifying questions    │
│  Q1: "Which authentication method?"                 │
│  Q2: "Include registration?"                        │
│  Q3: "Session duration?"                            │
│  Q4: "Password requirements?"                       │
│      └─ Option 4: "Clarification complete"          │
└──────────────────────┬──────────────────────────────┘
                       │ User selects options
                       ▼
┌─────────────────────────────────────────────────────┐
│  Iteration 2: Claude asks next 4 questions          │
│  (based on previous answers)                        │
│      └─ Option 4: "Clarification complete"          │
└──────────────────────┬──────────────────────────────┘
                       │ User selects "Clarification complete"
                       ▼
┌─────────────────────────────────────────────────────┐
│  Output: Before/After Summary                       │
│  <promise>CLARIFICATION COMPLETE</promise>          │
└─────────────────────────────────────────────────────┘
```

## Example

```
> /clarify Add a login feature

Clarify loop activated!
Original Requirement: "Add a login feature"
Max Questions: 3

---

[Claude asks 4 questions with 4 options each]

[You select options]

---

## Requirement Clarification Summary

### Before (Original)
"Add a login feature"

### After (Clarified)
**Goal**: Add username/password login with self-registration
**Scope**: Login, logout, registration
**Decisions Made**:
| Question | Decision |
|----------|----------|
| Auth method | Username/Password |
```

## Ambiguity Categories

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

## License

MIT
