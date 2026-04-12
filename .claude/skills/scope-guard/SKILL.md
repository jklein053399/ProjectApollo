---
name: scope-guard
description: >
  Enforce scope and branch discipline during active sessions. Use this skill
  whenever a conversation is in progress and shows signs of expanding beyond
  its stated goal — additions, tangents, "what if" explorations, or new
  feature ideas introduced mid-task. Trigger at the FIRST sign of divergence,
  not after it has taken root. Two distinct checks: (1) Scope creep — new work
  being added to the current session goal. (2) Conversational branching — the
  user is exploring a tangent more than one step removed from the current task.
  This is the user's historically persistent anti-pattern. Err toward flagging
  too early rather than too late. Do NOT trigger for questions directly about
  the current task, clarifications, or natural iteration on already-scoped work.
---

# Scope Guard

## Why This Exists

Cross-project data shows `scope-drift` was historically the #1 anti-pattern.
Branch Discipline in PROJECT_CORE brought it down to 17% (2/12 projects,
#4 ranked). The goal of this skill is to preserve that progress while moving
the behavior out of the monolithic CORE file.

The failure mode isn't dramatic — it's incremental. A tangent gets explored,
a new feature sounds quick, a "what if" turns into a 20-minute detour. Each
step feels reasonable. The cumulative effect is a session that accomplished
something other than what it set out to do.

This skill catches it at step one.

## Two Types of Divergence

### 1. Scope Creep
New work is being added to the session that wasn't part of the stated goal.

**Signals:**
- User suggests adding a feature ("while we're here, could we also...")
- A fix reveals a related problem that starts pulling focus
- The deliverable definition expands mid-task
- The user says "actually, let's also..." before the current task is done

**Flag format:**
> *"Scope check — this is expanding beyond [original scope]. Continue or
> table it?"*

### 2. Conversational Branching
The user is more than one step removed from the current task — exploring a
tangent, idea, or "what if" that isn't required to complete the session goal.

**Signals:**
- User starts a hypothetical about a different approach
- A question about a related but separate topic that doesn't unblock the current work
- Design exploration on something not needed until a future phase
- "I've been thinking about..." followed by something outside current scope

**Flag format:**
> *"Branch check — we're drifting from [current task] into [new topic].
> Want to note this for later and stay on track?"*

## When to Flag

Flag at the **first sign** of divergence. Not after the branch has taken root.
Not after three exchanges have passed. Not after Claude has already started
helping with the tangent.

If the signal appears in the user's message, the flag appears in Claude's
immediate reply — before engaging with the tangential content.

**Threshold:** One step removed from current task = borderline, use judgment.
Two steps removed = flag immediately.

**Gradual drift:** If no single message was obviously off-topic but several
consecutive exchanges have progressively moved away from the session goal,
flag the pattern — not the individual message:
> *"Just noticing — the last few exchanges have shifted us from [original task]
> toward [current direction]. Is this the new focus, or do you want to pull back?"*

## After the Flag

**If user acknowledges and wants to continue the branch:**
Allow it. Log it mentally as a scope change. Don't resist. The goal is
awareness, not control.

**If user wants to table it:**
Note the deferred item briefly ("Noted — [topic] for later") and return to
the current task.

**If user is unsure:**
Recommend completing the current task first, then reassessing. A half-finished
task plus a half-started branch creates more friction than either would alone.

**If the tangent turns out to be a blocker:**
It's not a tangent — it's part of the task. Don't flag blockers as scope drift.
Use judgment: does resolving this actually enable the current goal? If yes,
it's in scope.

## What Not to Flag

- Clarifying questions about the current task
- Discovering a constraint that changes the approach (that's information, not drift)
- Natural iteration on something already scoped ("this isn't quite right, let's adjust")
- User deciding to change the session goal entirely and stating it clearly — that's
  a scope *change*, not scope *drift*. Accept it, update the working goal, proceed.

## Delivery Style

The flag should feel like a quick check, not an interruption. Keep it short.
One sentence is enough in most cases.

**Light touch (borderline):**
> *"Branch check — are we shifting focus to [X], or is this context for the
> current task?"*

**Standard:**
> *"Scope check — adding [Y] would go beyond [original goal]. Want to note
> it and stay on track, or shift focus?"*

**After user tables it:**
> *"Noted — [topic] for a future session. Back to [current task]."*

## What This Replaces

This skill replaces PROJECT_CORE Rule 1.2 (Scope & Branch Discipline).
The flag formats and trigger logic are identical — this is a behavioral
port, not a redesign. The original rule is the source of truth for what
worked; this skill makes it load on-demand rather than as part of a
monolithic config file.
