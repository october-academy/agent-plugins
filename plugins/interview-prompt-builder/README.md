# Interview Prompt Builder Plugin

Build interview prompts that instruct Claude to gather requirements before executing tasks.

## Installation

```bash
claude plugin install interview-prompt-builder
```

## Usage

Trigger by asking Claude to help create an interview prompt:

- "Help me write a prompt for..."
- "Make an interview prompt"
- "I'm not sure what I want yet"

## Workflow

1. **Understand the target task** - What will Claude produce?
2. **Identify interview dimensions** - What needs clarification?
3. **Define interview behavior** - How should Claude ask questions?
4. **Generate the prompt** - Structured template output

## Interview Dimensions

| Dimension | What to Clarify |
|-----------|-----------------|
| Audience | Who will use this? Technical level? |
| Scope | Include/exclude? Depth vs. breadth? |
| Format | Structure, length, style, tone? |
| Constraints | Deadlines, limits, requirements? |
| Quality | How to measure success? |
| Context | Related work, references? |

## Example Output

```markdown
# Technical Blog Post - Interview Request

## Background
I'm writing a technical blog post. Interview me first.

## Interview Topics
1. Topic & scope
2. Audience
3. Structure
4. Tone
5. Constraints

## Interview Rules
- 1-2 questions per turn
- Push back on vague answers
- End when all topics have depth

## Output
Create `blog-post.md` with structured content.
```

## When to Use

**Use when:**
- User has a general idea but unclear requirements
- Task involves subjective choices
- Complex deliverables requiring multiple decisions

**Skip when:**
- Requirements are already clear
- Simple, well-defined tasks

## License

MIT
