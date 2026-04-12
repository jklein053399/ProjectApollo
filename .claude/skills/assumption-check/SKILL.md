---
name: assumption-check
description: >
  Verify assumptions before implementation. Use this skill BEFORE writing code,
  generating deliverables, or committing to an approach that depends on something
  unverified. Trigger when: starting implementation of a new feature or phase,
  switching to a different technical approach, building on inferred behavior of
  a platform/library/API, applying a data model or schema assumption, or when
  the user says "let's build" / "go ahead" / "implement" after a planning
  discussion. Also trigger when resuming work after a pause — stale assumptions
  are the most dangerous kind. Do NOT trigger for simple questions, research,
  brainstorming, or tasks where Claude is only producing text/analysis with no
  downstream implementation dependency.
---

# Assumption Check

## Why This Exists

Cross-project data shows `assumed-alignment` is the #1 anti-pattern at 50% of
projects. The failure mode is specific: a falsifiable assumption goes unverified
before building on it. Upfront specs and clarifying questions (which are already
happening at 83%) don't catch these — they're assumptions that *feel* obvious
but aren't.

This skill adds a 30-second verification pause at the moment it matters most:
right before implementation begins.

## When to Run the Check

Trigger the assumption check at these transition points:

1. **Planning → Building** — The user has described what they want, and Claude
   is about to start producing code or a structured deliverable.
2. **Phase → Phase** — Moving from one implementation phase to the next within
   a session (e.g., "data layer done, now building the UI").
3. **Resumed work** — Picking up a project after any pause. Prior assumptions
   may no longer hold.
4. **Approach change** — Switching tools, libraries, frameworks, or strategies
   mid-task.
5. **Moving on from a significant completion point** — When the user signals
   they are done with a meaningful unit of work and want to proceed to the next
   thing (e.g., "let's move on", "what's next", "that's done, now...", "let's
   tackle the next one"). Fire before starting the next phase to surface any
   assumptions baked into what was just completed before building on top of it.

Do NOT run the check for:
- Trivial tasks (< 5 minutes of work, single-file changes, formatting fixes)
- Follow-up iterations on already-validated work
- Pure research or brainstorming with no implementation commitment

## The Check (3 Steps)

### Step 1: Surface assumptions
Before starting implementation, identify the 1-3 most critical assumptions
the planned work depends on. State them as falsifiable claims:

> "This implementation assumes:
> 1. [specific claim that could be wrong]
> 2. [specific claim that could be wrong]"

Good assumptions to surface:
- Platform/runtime behavior ("QWebEngine renders canvas elements the same as Chrome")
- Data format expectations ("the API returns timestamps in ISO 8601")
- Dependency behavior ("this library handles RGBA color values")
- Schema or model assumptions ("the parent device is identified by the Metasys path")
- Scope assumptions ("this exit criterion is achievable within the current phase")

### Step 2: Classify each assumption
For each surfaced assumption, classify it:

- **Verified** — Already tested, documented, or confirmed by the user. Proceed.
- **Verifiable** — Can be checked in under 5 minutes (run a test, read docs,
  ask the user). Check it now before proceeding.
- **Accepted risk** — Cannot be quickly verified. State it explicitly so the
  user can decide whether to proceed or investigate first.

### Step 3: Proceed or pause
- If all assumptions are Verified → proceed to implementation.
- If any are Verifiable → run the quick verification first, then proceed.
- If any are Accepted Risk → state them clearly and let the user decide.
  Format: *"Proceeding with unverified assumption: [X]. If this turns out to
  be wrong, we'll need to [consequence]. Want to verify first or accept the risk?"*

## Delivery Style

This check should feel like a brief, natural pause — not a bureaucratic gate.
For simple cases, it's one sentence. For complex cases, it's a short list.

**Light touch (single clear assumption):**
> "Before I build this — I'm assuming the CSV uses comma delimiters, not tabs.
> That's based on the file extension. Want me to verify by reading the first
> few lines, or is that confirmed?"

**Standard (2-3 assumptions at a phase boundary):**
> "Before we move to the UI layer, here's what I'm building on:
> 1. The data engine returns results as a list of dicts — ✓ verified in S2
> 2. The user model includes an `email` field — verifiable, I can check the schema
> 3. The frontend framework supports hot reload — accepted risk, docs are unclear
>
> Let me check #2 quick. For #3, want to proceed or investigate?"

**Skip (trivial work):**
No check needed. Just do the work.

## What This Replaces

This skill replaces PROJECT_CORE Rule 1.1 (Ask Before Building) with a more
targeted intervention. Rule 1.1 catches missing requirements; this skill catches
hidden assumptions — the gap the cross-project data identified.

---

For real-world examples of assumptions this check should have caught, read
`references/audit-examples.md`.
