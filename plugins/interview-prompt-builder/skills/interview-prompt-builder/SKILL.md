---
name: interview-prompt-builder
description: Build effective interview prompts for Claude Code when users have incomplete or unclear requirements. Use when users want to create prompts that instruct Claude to interview them before executing a task. Triggers include requests like "help me write a prompt", "make an interview prompt", "I'm not sure what I want yet", or when a user's request is vague and would benefit from structured clarification.
user-invocable: true
---

# Interview Prompt Builder

Build prompts that instruct Claude Code to interview users before executing tasks, ensuring complete requirements gathering.

## When to Use

- User wants Claude Code to ask clarifying questions before starting work
- User has a general idea but hasn't fully defined requirements
- Task involves subjective choices (style, tone, structure, scope)
- Complex deliverables requiring multiple decisions

## Workflow

### 1. Understand the Target Task

Ask user about:
- **What Claude Code will ultimately produce** (document, code, analysis, etc.)
- **What's already defined vs. uncertain** in their requirements
- **Any existing materials** (drafts, references, examples) Claude should review first

### 2. Identify Interview Dimensions

Determine what the interview needs to clarify:

| Dimension | Example Questions to Uncover |
|-----------|------------------------------|
| **Audience** | Who will read/use this? Technical level? |
| **Scope** | What to include/exclude? Depth vs. breadth? |
| **Format** | Structure, length, style, tone? |
| **Constraints** | Deadlines, word limits, technical requirements? |
| **Quality criteria** | How will success be measured? |
| **Existing context** | Related work, prior decisions, references? |

### 3. Define Interview Behavior

Configure how Claude Code should conduct the interview:

```markdown
### Interview Rules
- **Questions per turn**: 1-2 (prevents overwhelm)
- **Follow-up behavior**: [deep dive on answers / move to next topic]
- **Challenge mode**: [yes: push back on vague answers / no: accept as-is]
- **Completion signal**: [checklist / user says "done" / all topics covered]
```

### 4. Generate the Prompt

Use this template structure:

```markdown
# [Task Name] - Interview Request

## Background
[What this task is about, key terms defined, goals]

## Existing Materials
[Files to read first, if any]

## Interview Topics (in order)
1. [Topic]: [What to uncover]
2. [Topic]: [What to uncover]
...

## Interview Rules
- Questions per turn: [n]
- Follow-up: [behavior]
- Challenge/push-back: [yes/no]
- End condition: [criteria]

## Output Instructions
When interview is complete, [create/modify] `[filename]`:
- [Structural requirements]
- [Content requirements]
- [Quality requirements]
```

## Example

**User request**: "I want Claude to interview me for writing a technical blog post"

**Generated prompt**:

```markdown
# Technical Blog Post - Interview Request

## Background
I'm writing a technical blog post. Interview me to understand the topic, audience, and style before writing.

## Interview Topics
1. **Topic & scope**: What technology/concept? What specific aspect? What's out of scope?
2. **Audience**: Technical level? What do they already know? What should they learn?
3. **Structure**: Tutorial vs. explanation vs. opinion? Code examples needed?
4. **Tone**: Formal/casual? First-person? Humor acceptable?
5. **Constraints**: Target length? SEO keywords? Publication platform?

## Interview Rules
- 1-2 questions per turn
- Push back if answers are vague ("Can you give a specific example?")
- Ask follow-up questions to reach concrete details
- End when all 5 topics have sufficient depth

## Output
Create `blog-post.md` with:
- Clear headline and introduction
- Structured sections matching discussed scope
- Code examples if identified as needed
- Tone matching user's stated preference
```

## Quality Checklist

Before finalizing the prompt, verify:

- [ ] Background section defines key terms and context
- [ ] Interview topics are specific, not generic
- [ ] Interview rules specify questions-per-turn and follow-up behavior
- [ ] End condition is measurable
- [ ] Output instructions are concrete and actionable
- [ ] Any existing files are referenced for Claude to read first
