---
name: memory-refresher
description: >
  Generate a structured refresher when the user has been away from a project
  and needs to get re-oriented. Trigger on phrases like "I'm a little behind",
  "refresh me", "give me a refresher", "where do we stand", "I'm rusty on
  this", "remind me where we are", or any explicit "Skill: Refresher" /
  "Task: Refresher" invocation. Distinct from where-we-left-off, which
  *writes* state at session end; this skill *reconstructs* state at session
  start when the user has lost the thread.
---

# Memory Refresher

## Purpose

When the user returns to a project after a gap and is no longer holding
the full context in their head, generate a calm, structured map of where
things stand. This is not a status report — it's an orientation document
designed to bring a human back up to speed in under two minutes of reading.

The output should answer four questions, in this order:

1. **Is anything broken or wrong** in whatever the user is currently looking at?
2. **Where do we stand** across the active workstreams?
3. **What documents are out of date?**
4. **What decisions are unresolved?**

## Triggers

Soft triggers (use judgment — confirm relevance before invoking):

> "I'm a little behind"
> "refresh me"
> "give me a refresher"
> "where do we stand"
> "I'm rusty on this"
> "remind me where we are"
> "it's been a minute"
> "I need to catch up"

Hard triggers (always invoke):

> `Skill: Refresher`
> `Task: Refresher`
> `Skill: Memory Refresher`

## Workflow

### Step 1: Pull recent state from authoritative sources

In order, read:

1. **Memory** (`MEMORY.md` and any referenced project memory files) — for
   the user's standing context, blockers, and active workstreams.
2. **Latest session handoff** — find the most recent file in the project's
   handoff/session-doc location (e.g., `_Meta/docs/sessions/Handoff-*.md`,
   `WHERE-WE-LEFT-OFF.md`, `PROJECT_CONTEXT.md`).
3. **Git log** — `git log --oneline -15` for the last commits.
4. **Git status** — what's uncommitted right now.
5. **Anything the user just asked about specifically** — read those files
   directly so you can answer the "is it broken" question with evidence.

Do NOT exhaustively crawl the project. The goal is orientation, not audit.

### Step 2: Answer the four questions

**Q1: Is anything wrong with [the thing the user is looking at]?**

If the user named a specific file or component, evaluate it against the
current state of the project. Categorize findings as:

- **Broken** — contradicts current state or has dead pointers
- **Stale** — references outdated versions but still factually correct
- **Incomplete** — gaps where newer changes haven't been folded in
- **Fine** — internally consistent and current

If nothing was named, skip Q1 and go to Q2.

**Q2: Where do we stand?**

Build a workstream table. For each active stream, list: state (Done /
In Progress / Paused / Blocked / Not Started), and a one-line note. Pull
from memory's project entries — those are the source of truth for what
the user considers active.

| Workstream | State | Note |
|---|---|---|

Identify the **key tension** — the thing that's preventing forward
motion right now, if there is one. Surface it explicitly.

**Q3: Out-of-date documents?**

List documents that are stale based on what you read. For each, give
severity (Severe / Moderate / Minor) and a one-line "what to do".
Include documents you *haven't* personally verified — flag them as
"worth checking" rather than asserting staleness.

**Q4: Unresolved decisions?**

List open decisions in order of how much they're blocking other work.
Cross-reference memory entries that mention BLOCKED status. Distinguish:

- **Carried over** — decisions that were already open before this gap
- **New** — decisions introduced by changes that landed during the gap
- **Operational** — decisions about what to do next, separate from
  schema/spec questions

### Step 3: Recommend (lightly)

End with one paragraph: **"My honest take on what to do first."** This
is not a directive — it's a recommendation the user can override. Frame
it as a fork in the road if there's genuinely a choice to make.

## Output Contract

- **Length:** 300–600 words for a typical mid-project gap. Longer only
  if the project sprawls.
- **Tone:** Calm and grounded. The user is already feeling behind —
  don't add to it with urgency or alarm.
- **Specificity:** Cite file paths and line numbers when claiming
  something is wrong. "Line 692 references a dead Somnabulator path"
  beats "the file has a broken reference somewhere".
- **Honesty about gaps:** If you didn't read a file, say so. "I haven't
  checked X — worth a read-through" is more useful than guessing.
- **No tasks created.** This skill produces a document, not a task list.
  The user can ask for tasks afterward if they want.

## What This Does NOT Do

- Does not write or update memory — that's normal memory operations
- Does not generate a handoff — that's `where-we-left-off`
- Does not fix the stale documents it identifies — that's a follow-up
  task the user can request
- Does not fire automatically — only on explicit trigger phrases
- Does not crawl the entire project — orientation, not audit
