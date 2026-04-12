---
name: session-contract
description: >
  Establish a session contract at the start of every new conversation within
  a project. Trigger immediately on the first message of any session where a
  project context exists (PROJECT_CONTEXT.md in the knowledge base, a
  .claude-config/ directory, or any clear project framing). The contract
  establishes: goal, scope boundary, constraints, and exit criteria — delivered
  as a natural conversational beat, not a form. Also trigger the auto-setup
  walkthrough when PROJECT_CONTEXT.md contains unfilled placeholder values.
  Do NOT re-trigger mid-session on every message. Do NOT trigger for
  one-off questions with no project context, casual conversation, or when
  the user has already clearly established all four contract elements in their
  opening message. This skill directly addresses the no-spec (33%) and
  assumed-alignment (50%) anti-patterns by locking in shared understanding
  before any work begins.
---

# Session Contract

## Why This Exists

Two of the top three recurring anti-patterns — `no-spec` (33% of projects)
and `assumed-alignment` (50%) — share the same root cause: work begins before
goal, scope, and success criteria are agreed on. The session contract is a
30-second fix at the only moment it can actually prevent those failures: the
start of the session, before anything is built.

This is the most-used behavioral rule in the system. It fires at the start
of every conversation, every time.

## The Four Contract Elements

At session start, establish these four things — in whatever order the
conversation naturally surfaces them:

1. **Goal** — What are we accomplishing this session? One concrete outcome.
2. **Scope boundary** — What's explicitly in bounds? What's explicitly out?
3. **Constraints** — Format, voice, tools, dependencies, platform, time.
4. **Exit criteria** — How do we know this session is done? Concrete, not vibes.

All four matter, but **exit criteria** is the one most often skipped and
the one that causes the most rework. "Done" should be a testable condition,
not a feeling.

## How to Run It

### Clear opener (specific goal, most elements implied)

Confirm the contract in 1-2 sentences and get to work. Don't interrogate a
user who has already given you what you need.

> **User:** "I need to add CSV export to the parser. Output: device name,
> address, status."
>
> **Claude:** "Got it — CSV export with those three columns, scoped to export
> only, no parser changes. I'll call it done when you have a working export
> function to test. Any format preferences, or standard comma-delimited?"

### Vague opener (goal unclear, scope undefined)

Ask the minimum questions to establish the four elements. Don't ask four
separate questions — read what's already implied and ask only for what's
genuinely missing.

> **User:** "Let's work on the parser today."
>
> **Claude:** "Sure — what's the focus? Adding something new, fixing a bug,
> or refactoring? And what does done look like by the end of the session?"

### Continuation ("picking up from last session")

Review available context (PROJECT_CONTEXT.md session history, conversation
history, any handoff doc). Propose a contract based on where things left off.
The user confirms or corrects.

> **Claude:** "Picking up from last time — we'd finished the data layer and
> were about to start the UI. Does that sound right? If so, I'd scope this
> session to the list view and call it done when it renders real data from
> the parser."

### No project context (one-off question, no KB)

Skip the contract. Don't force project framing onto casual or isolated
requests. The contract exists to protect ongoing work — it doesn't apply
to standalone questions.

## Delivery Rules

- **Conversational, not a form.** Never present the four elements as a
  numbered list or checklist. Weave them into natural language.
- **Minimum viable friction.** If the user has given you 3 of 4 elements,
  ask about the missing one — don't re-ask for the ones already clear.
- **Confirm, don't interrogate.** For clear openers, state your read of the
  contract and ask one narrow clarifying question if needed. Don't pepper
  the user with questions before starting.
- **Adapt to energy level.** Match the user's tone. A blunt one-liner opener
  gets a blunt one-liner confirmation.

## Auto-Setup: Blank PROJECT_CONTEXT.md

If PROJECT_CONTEXT.md contains unfilled placeholder values (e.g., `_[name]_`,
`_[YYYY-MM-DD]_`, `_[Coding / Research / Design / Writing / Mixed]_`), run
the setup walkthrough **before** the normal session contract.

**Setup flow:**
1. Flag the blank template: *"Looks like this project hasn't been set up yet.
   Want to do that now? Takes about a minute."*
2. Ask for (in conversational sequence, not a form dump):
   - Project name and type
   - 2-3 sentence description
   - Current goal and success criteria
   - Key constraints (language, platform, tools, etc.)
   - Phase, timeline, priority
3. Generate a completed PROJECT_CONTEXT.md for download.
4. Instruct the user to replace the blank template in the knowledge base
   (web) or `.claude-config/` directory (Claude Code).
5. Once setup is confirmed, proceed to the normal session contract.

**Init from Backup shortcut:** If a `BACKUP_*.md` file is present and
contains project metadata, session history, and decision log, pre-fill
PROJECT_CONTEXT.md from the backup and present it for confirmation instead
of running the interactive Q&A.

## What This Doesn't Do

- Doesn't enforce scope mid-session — that's `scope-guard`
- Doesn't verify implementation assumptions — that's `assumption-check`
- Doesn't update PROJECT_CONTEXT.md at session end — that's `context-handoff`
- Doesn't replace the `Initialize from Backup` command for full project
  rebuilds — this skill handles the lightweight session-start case only

## Anti-Patterns This Prevents

| Anti-pattern | How the contract catches it |
|---|---|
| `no-spec` | Exit criteria are defined before work starts |
| `assumed-alignment` | Goal and scope are stated explicitly, not assumed |
| `scope-drift` | Scope boundary is named upfront; `scope-guard` enforces it |
| `over-context` | Minimum-viable-friction rule prevents unnecessary pre-work |
