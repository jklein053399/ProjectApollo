---
name: session-planning
description: >
  Structure work correctly before implementation begins. Use this skill when
  a task is being scoped and shows signs of being too large for one session,
  too undivided for safe implementation, or starting with design before
  there's something working to design around. Trigger when: a task involves
  research across multiple topics plus a deliverable, a technical project is
  about to produce documentation or specs before any code exists, or a
  codebase or document is growing toward monolithic. Also trigger when a user
  says "let's plan out how we'll do this" or is about to start a multi-phase
  build. Do NOT trigger mid-task on work already in progress — this skill
  shapes work before it starts, not after. Do NOT trigger for small, focused
  tasks that are clearly scoped to one session.
---

# Session Planning

## Why This Exists

`monolithic-prompt` accounts for 25% of projects in the cross-project audit —
batching too much into one session, one file, or one pass. The failure mode
is predictable: large undivided tasks produce output that's harder to review,
harder to correct, and harder to build on. Small, well-shaped units of work
compound positively. Large ones create rework.

This skill governs how work gets structured before implementation starts.
Three rules, each targeting a distinct failure mode.

---

## Rule 1: Split Research from Synthesis

**Trigger:** A task involves research across 3+ topics AND produces a
formatted deliverable (document, report, spec, summary).

**The problem:** Research and synthesis are different cognitive modes.
Running them in the same session degrades both — the research gets
shallow, the synthesis gets rushed.

**The call:** Recommend splitting before starting.

> *"This has research across [X topics] plus a deliverable. Worth splitting —
> Session A for research and raw findings, Session B for synthesis and the
> actual output. Cleaner result, easier to course-correct. Want to proceed
> that way, or run it in one pass?"*

User can override. Surface the recommendation once, don't repeat it.

**When not to split:**
- Research is shallow (one source, one topic)
- The deliverable is a direct output of the research with no synthesis step
- The user has already done the research and just needs the deliverable

---

## Rule 2: Build Before You Design (Technical Projects)

**Trigger:** A technical or coding project is about to produce design
documentation, architecture specs, or planning artifacts before any
working code exists.

**The problem:** Design documents written before implementation are
speculative. They describe a system that hasn't been stress-tested by
reality. The design changes once you start building — often significantly —
which means the docs become stale and the rework is double.

**The call:** Push toward a minimal working prototype first.

> *"Before we document the architecture, it's worth getting something
> running first — even a minimal version. Design tends to be more accurate
> once you've built against the constraints. Want to start with a working
> prototype?"*

**The pattern:** Build the smallest thing that runs → learn from what
building it revealed → design around what you now know.

**When to design first:**
- External stakeholders require a spec before any build can begin
- The project has hard constraints that make exploratory builds impractical
- A prior prototype already exists and the design is clarifying it, not
  preceding it

---

## Rule 3: Modular by Default

**Trigger:** A codebase file is approaching ~500 lines, a document is
growing without section breaks, or a session is being planned around
one large undivided deliverable.

**The problem:** Monolithic outputs are harder to review, harder to
iterate on, and harder to hand off. A 1,200-line file and a 40-page
unsectioned document have the same problem: you can't work on one part
without touching everything.

**The calls:**

*For code:*
> *"This file is approaching 500 lines. Worth proposing a split before
> it gets harder to refactor — [suggested module structure]. Want to
> do that now or finish the current feature first?"*

*For documents:*
Break large deliverables into independently iterable sections from
the start. Name them, scope them, build them one at a time. Don't
draft the whole thing and then section it.

*For sessions:*
One session per feature or focused task. If the plan for this session
covers more than one distinct deliverable, flag it:
> *"This session plan has [X] and [Y] — those are probably two sessions.
> Which one first?"*

**Threshold for code:** ~500 lines is a soft ceiling, not a hard rule.
Flag it, let the user decide. Don't refactor without asking.

---

## How These Three Rules Interact

They're ordered by when they apply:

1. **Split research from synthesis** — applies at session planning time,
   before anything starts.
2. **Build before you design** — applies at project planning time, when
   deciding what kind of work comes first.
3. **Modular by default** — applies continuously, as work grows.

They can all trigger in the same session. A technical project might need
all three: split the research phase from the build phase, build before
documenting, and keep each module under 500 lines.

## What This Replaces

This skill replaces PROJECT_CORE Rules 1.3 (Multi-Session Default),
1.4 (Build Before You Design), and 1.5 (Modular by Default). Grouped
because they share a trigger point — structuring work before it starts —
and a common failure mode they prevent: too much, too undivided,
too soon.
