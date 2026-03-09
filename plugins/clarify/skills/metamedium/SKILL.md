---
name: metamedium
description: Analyzes whether a problem requires content optimization or structural format redesign, then delivers a labeled classification, branching recommendations, and a structured form-opportunity report for each path. Use when output quality improves slowly despite more effort, the same format keeps being reused, or you're deciding between incremental optimization vs structural redesign. Trigger on '내용 vs 형식', 'content vs form', 'metamedium', '형식을 바꿔볼까', '새로운 포맷', 'perspective shift', 'diminishing returns', 'should I change the format', 'is this a content problem', 'try a different approach', 'stuck in the same pattern'.
user-invocable: true
argument-hint: [work-or-plan]
---

# Metamedium: Content vs Form Reframing

Distinguish **content** (what is produced) from **form** (the medium/structure that produces or delivers it) to decide where leverage is highest.

## When to Use

- Output quality improves slowly despite more effort
- Repeatedly producing content inside the same format
- Deciding between incremental optimization vs structural redesign

For requirement clarification, use **vague**. For strategy blind spots, use **unknown**.

## Core Idea

- Content optimization is usually linear
- Form redesign can be multiplicative

Use this question when stuck:

`What new form could make this recurring problem disappear?`

## Classification Examples

| Activity | Label | Reasoning |
|----------|-------|-----------|
| Writing this week's status report | `[CONTENT]` | One-off direct output |
| Building a reusable report template | `[FORM]` | Enables repeated outputs |
| Editing a blog post | `[CONTENT]` | Direct artifact |
| Designing a content calendar | `[FORM]` | System that produces posts |

## Protocol

### Phase 1: Label

Classify the user's current activities:
- `[CONTENT]` direct outputs (doc, code change, campaign copy)
- `[FORM]` systems/pipelines/templates/tools enabling repeated outputs

### Phase 2: Fork (AskUserQuestion required)

Ask user to choose one path using options:
- Proceed with content optimization
- Explore form redesign
- Content now, track form opportunity

### Phase 3: Branch

If content:
- Proceed and add a `Form Opportunity` note

If form:
- Propose 2-3 alternative forms
- For each: structure, new properties, minimum viable test

If hybrid:
- Deliver content outcome plus deferred form backlog item

### Phase 4: Output

```markdown
## Content/Form Analysis

**Current work**: [description]
**Classification**: [CONTENT / FORM]

### Form Opportunity
| Field | Detail |
|-------|--------|
| Alternative form | ... |
| New properties | ... |
| Minimum test | ... |
| Status | exploring / later / rejected |
```

**Example filled output** (user writing weekly reports → exploring form redesign):

```markdown
## Content/Form Analysis

**Current work**: Writing weekly status reports for the team
**Classification**: [CONTENT] — one-off direct output each week

### Form Opportunity
| Field | Detail |
|-------|--------|
| Alternative form | Async Loom video update + bullet summary doc |
| New properties | Adds tone/nuance; reduces reading load; skimmable transcript |
| Minimum test | Replace one written report with a 3-min video this Friday |
| Status | exploring |
```

## Rules

1. Always label current work first
2. Do not force form redesign when costs exceed leverage
3. If user stays with content, still preserve at least one form option
4. Prefer testable form changes over abstract ideation

## Additional Resources

- `references/alan-kay-quotes.md`
