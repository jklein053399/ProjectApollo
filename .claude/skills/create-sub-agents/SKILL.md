---
name: create-sub-agents
description: Create and dispatch parallel sub-agents with structured work orders. Use when the user wants to run multiple agents concurrently to perform batch operations across files or domains.
argument-hint: [task description or file list]
allowed-tools: Agent, Read, Glob, Grep, Bash
---

# Create Sub-Agents

Dispatch parallel sub-agents using structured work orders. Each agent receives a self-contained prompt with everything it needs to complete its task independently.

## Process

### 1. Understand the Request

Parse `$ARGUMENTS` to determine:
- **What work** needs to be done (update, create, analyze, etc.)
- **Which files/domains** are targets
- **How many agents** to dispatch (default: up to 25 concurrent)
- **What model** to use (default: inherit from parent; user can request haiku/sonnet for cost savings)

If the user's request is ambiguous, ask for clarification before dispatching.

### 2. Discover Targets

If the user hasn't specified exact files, use Glob/Grep/Read to identify the target files. Build a list of `(file_path, context)` pairs.

### 3. Build Work Orders

For each agent, construct a **self-contained work order** prompt. Every work order MUST include:

```
WORK ORDER — Agent [N] of [Total]
================================

TARGET: [absolute file path]
TASK: [specific action to perform]

CONTEXT:
- [any information the agent needs to understand the file's role]
- [relevant cross-references, conventions, or domain knowledge]

INSTRUCTIONS:
1. [step-by-step what to do]
2. [be explicit — the agent has zero prior context]
3. [include style/format requirements]

CONSTRAINTS:
- [what NOT to do]
- [boundaries to stay within]

DONE WHEN: [clear completion criteria]
```

Key principles for work orders:
- **Self-contained**: Agent has never seen this conversation. Include everything.
- **Specific**: Name exact files, exact changes. No ambiguity.
- **Bounded**: Tell the agent what NOT to touch. Prevent scope creep.
- **Verifiable**: Define what "done" looks like so the agent can self-check.

### 4. Dispatch

- Launch all agents in a **single message** with multiple Agent tool calls
- Set `model` parameter if user requested a specific model
- Use `isolation: "worktree"` when agents are editing files to avoid conflicts
- For read-only tasks (analysis, search), worktree isolation is not needed

### 5. Report Results

After all agents return:
- Summarize successes and failures in a concise table
- Flag any agents that reported issues or made unexpected changes
- If using worktrees, report which branches contain changes

## Cost Awareness

| Agent count | Model  | Estimated tokens (medium workload) |
|-------------|--------|------------------------------------|
| 5           | opus   | ~75-125K                           |
| 10          | opus   | ~150-250K                          |
| 25          | opus   | ~375-625K                          |
| 25          | haiku  | ~375-625K (60x cheaper per token)  |

Inform the user of approximate cost before dispatching if running >10 agents.

## Example Invocations

- `/create-sub-agents update all stub files in Physics/ with expanded content`
- `/create-sub-agents analyze cross-links across all 38 domains and report gaps`
- `/create-sub-agents add YAML frontmatter to every .md file missing it`
