---
name: wrap
description: Runs a multi-agent session wrap-up workflow that checks git status, analyzes completed work in parallel (documentation updates, automation opportunities, learning points, follow-up tasks), validates results for duplicates, and executes user-selected actions such as creating a commit, updating CLAUDE.md, or generating a new skill. Use when user asks to "wrap up session", "end session", "/wrap", or wants to analyze completed work before ending.
user-invocable: true
disable-model-invocation: true
argument-hint: [notes]
---

# Wrap Skill

Comprehensive session wrap-up workflow with multi-agent analysis.

## Step 1: Check Git Status

```bash
git status --short
git diff --stat HEAD~3 2>/dev/null || git diff --stat
```

## Step 2: Phase 1 - Analysis Agents (Parallel)

Execute 4 agents in a single message (parallel Task calls).

### Session Summary (Provide to all agents)

Build a summary from git output and conversation context. Example:

```
Session Summary:
- Work: Implemented OAuth2 login flow and added unit tests for auth middleware
- Files: src/auth/oauth.py (created), src/middleware/auth.py (modified), tests/test_auth.py (created)
- Decisions: Used PyJWT over authlib for smaller dependency footprint; deferred refresh-token rotation to next sprint
```

### Parallel Execution

Dispatch all four agents in a single message. Full example for **doc-updater**; use the same pattern for the remaining three:

```
Task(
    subagent_type="doc-updater",
    prompt="""
You are a documentation updater. Review the session summary and propose specific additions or edits to CLAUDE.md or context.md.

## Session Summary
- Work: Implemented OAuth2 login flow and added unit tests for auth middleware
- Files: src/auth/oauth.py (created), src/middleware/auth.py (modified), tests/test_auth.py (created)
- Decisions: Used PyJWT over authlib for smaller dependency footprint; deferred refresh-token rotation to next sprint

## Your Task
1. Read the current CLAUDE.md (if present).
2. Identify facts, conventions, or decisions from the session worth persisting.
3. Output the exact text to add or the exact lines to change — no vague summaries.

Return your proposals in this format:
## doc-updater proposals
<section name>: <exact content to insert or replace>
"""
)

Task(subagent_type="automation-scout", prompt=<same pattern — detect automation patterns, output skill/command/agent suggestions>)
Task(subagent_type="learning-extractor", prompt=<same pattern — extract learning points, output TIL format summary>)
Task(subagent_type="followup-suggester", prompt=<same pattern — suggest follow-up tasks, output prioritized task list>)
```

| Agent | Role | Output |
|-------|------|--------|
| **doc-updater** | CLAUDE.md/context.md updates | Specific content to add |
| **automation-scout** | Detect automation patterns | skill/command/agent suggestions |
| **learning-extractor** | Extract learning points | TIL format summary |
| **followup-suggester** | Suggest follow-up tasks | Prioritized task list |

## Step 3: Phase 2 - Validation Agent

Run after Phase 1 completes.

```
Task(
    subagent_type="duplicate-checker",
    prompt="""
Validate Phase 1 results.

## doc-updater proposals:
[doc-updater results]

## automation-scout proposals:
[automation-scout results]
"""
)
```

## Step 4: Integrate Results

```markdown
## Wrap Analysis Results

### Documentation Updates
[doc-updater summary]
- Duplicate check: [duplicate-checker feedback]

### Automation Suggestions
[automation-scout summary]
- Duplicate check: [duplicate-checker feedback]

### Learning Points
[learning-extractor summary]

### Follow-up Tasks
[followup-suggester summary]
```

## Step 5: Action Selection

```
AskUserQuestion(
    questions=[{
        "question": "Which actions would you like to perform?",
        "header": "Wrap Options",
        "multiSelect": true,
        "options": [
            {"label": "Create commit (Recommended)", "description": "Commit changes"},
            {"label": "Update CLAUDE.md", "description": "Document new knowledge"},
            {"label": "Create automation", "description": "Generate skill/command/agent"},
            {"label": "Skip", "description": "End without action"}
        ]
    }]
)
```

## Step 6: Execute Selected Actions

Execute only user-selected actions.

---

## Quick Reference

### When to Use

- End of significant work session
- Before switching to different project
- After completing a feature or fixing a bug

### When to Skip

- Very short session with trivial changes
- Only reading/exploring code
- Quick one-off question answered

### Arguments

- Empty: Proceed interactively (full workflow)
- Message provided: Use as commit message directly
