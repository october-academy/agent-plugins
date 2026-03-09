---
name: feature-dev
description: Guides end-to-end implementation of new features by analyzing existing code patterns, designing module structure, and ensuring architectural consistency. Use when the user asks to implement a new feature, add functionality, build something new, or needs guidance on where to place new code, how to design a module or API, or how to integrate new behavior into an existing codebase. Triggered by phrases like 'add feature', 'implement X', 'build functionality', 'new module', 'where should I put this code', 'code organization', or 'design this feature'.
user-invocable: true
argument-hint: Optional feature description
allowed-tools: WebSearch
---

# Feature Development

Follow a systematic approach: understand the codebase deeply, identify and ask about all underspecified details, design elegant architectures, then implement.

## Core Principles

- **Ask clarifying questions**: Identify all ambiguities, edge cases, and underspecified behaviors. Ask specific, concrete questions rather than making assumptions. Wait for user answers before proceeding with implementation. Ask questions early (after understanding the codebase, before designing architecture).
- **Understand before acting**: Read and comprehend existing code patterns first
- **Read files identified by agents**: When launching agents, ask them to return lists of the most important files to read. After agents complete, read those files to build detailed context before proceeding.
- **Simple and elegant**: Prioritize readable, maintainable, architecturally sound code
- **Use TodoWrite**: Track all progress throughout — create the todo list in Phase 1 and update statuses as each phase completes.

---

## Phase 1: Discovery

**Goal**: Understand what needs to be built

Initial request: $ARGUMENTS

**Actions**:
1. Create todo list covering all phases, e.g.:
   ```
   TodoWrite([
     { id: "1", content: "Phase 1: Discovery", status: "in-progress" },
     { id: "2", content: "Phase 2: Codebase Exploration", status: "pending" },
     { id: "3", content: "Phase 3: Clarifying Questions", status: "pending" },
     { id: "4", content: "Phase 4: Architecture Design", status: "pending" },
     { id: "5", content: "Phase 5: Implementation", status: "pending" },
     { id: "6", content: "Phase 6: Quality Review", status: "pending" },
     { id: "7", content: "Phase 7: Summary", status: "pending" }
   ])
   ```
2. If feature unclear, ask user for:
   - What problem are they solving?
   - What should the feature do?
   - Any constraints or requirements?
3. Summarize understanding and confirm with user

---

## Phase 2: Codebase Exploration

**Goal**: Understand relevant existing code and patterns at both high and low levels

**Actions**:
1. Launch 2-3 code-explorer agents in parallel. Each agent should trace through the code comprehensively, focus on a different aspect of the codebase, and **return a list of 5-10 key files to read**. Adapt `[feature]` / `[area]` to the actual request:
   - `"Find features similar to [feature] and trace through their implementation comprehensively. Return a list of the 5-10 most important files."`
   - `"Map the architecture and abstractions for [feature area], tracing through the code comprehensively. Return a list of the 5-10 most important files."`

   Other useful angles: similar features, high-level architecture, UI patterns, testing approaches, extension points.

2. Once the agents return, read all files identified by agents to build deep understanding
3. Present comprehensive summary of findings and patterns discovered

---

## Phase 3: Clarifying Questions

**Goal**: Fill in gaps and resolve all ambiguities before designing

**Actions**:
1. Review the codebase findings and original feature request
2. Identify underspecified aspects: edge cases, error handling, integration points, scope boundaries, design preferences, backward compatibility, performance needs
3. **Present all questions to the user in a clear, organized list**
4. **Wait for answers before proceeding to architecture design**

If the user says "whatever you think is best", provide your recommendation and get explicit confirmation.

---

## Phase 4: Architecture Design

**Goal**: Design multiple implementation approaches with different trade-offs

**Actions**:
1. Launch 2-3 code-architect agents in parallel with different focuses. Each agent should list trade-offs and key files involved:
   - `"Design a minimal-change implementation of [feature] that maximises reuse of existing code. List trade-offs and key files involved."`
   - `"Design a clean-architecture implementation of [feature] prioritising maintainability and elegant abstractions. List trade-offs and key files involved."`
   - `"Design a pragmatic implementation of [feature] balancing speed and quality. List trade-offs and key files involved."`
2. Review all approaches and form your opinion on which fits best for this specific task (consider: small fix vs large feature, urgency, complexity, team context)
3. Present to user: brief summary of each approach, trade-offs comparison, **your recommendation with reasoning**, concrete implementation differences
4. **Ask user which approach they prefer**

---

## Phase 5: Implementation

**Goal**: Build the feature

**Wait for explicit user approval before starting implementation.**

**Actions**:
1. Wait for explicit user approval
2. Read all relevant files identified in previous phases
3. Implement following chosen architecture
4. Follow codebase conventions strictly
5. Write clean, well-documented code
6. Update todos as you progress

---

## Phase 6: Quality Review

**Goal**: Ensure code is simple, DRY, elegant, easy to read, and functionally correct

**Actions**:
1. Launch 3 code-reviewer agents in parallel:
   - `"Review [files] for simplicity, DRY principles, and elegance. List issues by severity."`
   - `"Review [files] for bugs and functional correctness. List issues by severity."`
   - `"Review [files] for adherence to project conventions and proper use of existing abstractions. List issues by severity."`
2. Consolidate findings and identify highest severity issues that you recommend fixing
3. **Present findings to user and ask what they want to do** (fix now, fix later, or proceed as-is)
4. Address issues based on user decision

---

## Phase 7: Summary

**Goal**: Document what was accomplished

**Actions**:
1. Mark all todos complete
2. Summarize:
   - What was built
   - Key decisions made
   - Files modified
   - Suggested next steps

---
