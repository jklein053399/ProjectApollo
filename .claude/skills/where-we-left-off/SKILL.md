---
name: where-we-left-off
description: >
  Generate a WHERE-WE-LEFT-OFF handoff capturing session state for continuity
  into the next session. Trigger on exact keywords: "Skill: Handoff",
  "Task: Handoff", "Skill: WWLO", or "Task: WWLO". Appends directly to
  PROJECT_CONTEXT.md session history. Do NOT trigger speculatively — only
  on explicit invocation. Distinct from context-handoff, which offers this
  at session end; this skill builds it on demand at any point in a session.
---

# Where We Left Off

## Purpose

Generates a structured handoff document on demand — not just at session end.
Useful mid-session when switching environments, handing off to another Claude
instance, or capturing state before a long pause.

Complements `context-handoff`, which proactively offers this at session close.
This skill builds it immediately, on command, at any point.

## Triggers

Any of the following:

> `Skill: Handoff`
> `Task: Handoff`
> `Skill: WWLO`
> `Task: WWLO`

## Environment Detection

Before generating, determine which environment is active:

**Claude Web** — generate a `WHERE-WE-LEFT-OFF.md` file for download and
knowledge base upload.

**Claude Code** — append a session entry directly to
`.claude-config/PROJECT_CONTEXT.md` session history. No separate file needed.

If environment is ambiguous, default to file output.

## Workflow

### Step 1: Gather session state

Review available context — conversation history, PROJECT_CONTEXT.md if
present, any open deliverables or decisions from this session.

### Step 2: Build the document

Use this structure:

```markdown
# WHERE-WE-LEFT-OFF.md
> Session handoff — [YYYY-MM-DD]
> Project: [project name or "unknown if no context available]

## Done This Session
> What was completed. One line per item.

- [completed item]

## Pending
> Work started but not finished. Be specific — "halfway through X" is
> more useful than "working on X".

- [pending item]

## Decisions Made
> Key choices that affect next session. Include the reasoning if it
> wasn't obvious.

- [decision] — [why]

## Open Questions
> Unresolved issues that will need to be addressed before or during
> the next session.

- [question or blocker]

## Next Session
> Recommended scope for the next session — one sentence.

[recommended scope]
```

### Step 3: Deliver

Append to `.claude-config/PROJECT_CONTEXT.md` session history in the
format: `[YYYY-MM-DD] S# — [focus] — [outcome]`
Confirm the write in one line.

## Output Contract

- Filename: `WHERE-WE-LEFT-OFF.md` exactly — no date suffixes, no project
  name prefixes. One file, always the same name, always overwritten.
- Content: Honest and specific. "Halfway through the parser refactor,
  stopped at the module split" is useful. "Working on the parser" is not.
- Length: As short as the session warrants. A 20-minute session might
  need three lines. A 3-hour session might need fifteen.

## What This Does NOT Do

- Does not update PROJECT_CONTEXT.md on Claude Web — that's `context-handoff`
- Does not generate a CPO — that's `generate-cpo`
- Does not trigger automatically at session end — that's `context-handoff`
- Does not fire speculatively on general session-winding-down language
