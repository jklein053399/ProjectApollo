---
name: generate-cpo
description: >
  Generate a Claude Project Overview (CPO) document for cross-project analytics.
  Use this skill when a project is completing, pausing, or being archived — or
  when the user explicitly asks to generate a CPO, project overview, or project
  summary for analytics. Trigger on phrases like "generate overview", "close out
  this project", "let's wrap up", "generate CPO", "project overview", or when
  the user updates project status to Paused or Archived. Also trigger when the
  user says "I think we're done" or is clearly finishing final deliverables.
  Do NOT trigger for mid-project status updates, session summaries, or general
  project questions — only at project close or meaningful stopping points.
---

# Generate CPO

Produces a structured project overview for cross-project pattern analysis.
The CPO captures what worked, what didn't, and why — in a format that enables
comparison across projects over time.

## Generation Workflow

### Step 1: Gather sources
Review all available context in this priority order:
1. **Session tags** — User-logged entries in format `Session log: S# — [focus] — [outcome]`
2. **PROJECT_CONTEXT.md** — Session history, decision log, project identity
3. **Conversation history** — What actually happened across sessions
4. **Knowledge base files** — Specs, deliverables, and reference material

If relying on conversation history rather than session tags, mark affected
metrics with `(estimated)` in the output.

### Step 2: Assess complexity
Use these criteria — they determine how the CPO will be compared against others:

| Level | Criteria |
|---|---|
| **Low** | 1–3 sessions, single deliverable type, minimal decision points |
| **Medium** | 4–8 sessions, 2+ deliverable types or moderate scope changes |
| **High** | 9+ sessions, multiple deliverable types, significant scope evolution or rework |

### Step 3: Identify gaps
Before generating, check for missing information. Common gaps:
- Start/close dates (ask the user)
- Session count (count from history, confirm with user)
- Whether scope changes were deliberate or drift (important for tagging)

Ask the user to fill gaps you can't confidently infer. Don't guess at facts
that affect pattern analysis — the whole point is accurate cross-project data.

### Step 4: Tag patterns
Every entry in Effective Patterns and Ineffective Patterns must be tagged.
Read `references/pattern-tags.md` for the controlled vocabulary.

Tagging rules:
- Use the most specific tag that fits. `scope-drift` over `custom`.
- A single pattern can have multiple tags if it genuinely spans categories.
- If nothing fits, use `custom` and write a clear definition — this flags
  the vocabulary for expansion.
- Tags are the primary key for cross-project matching. Freeform descriptions
  are context, not the matching mechanism.

### Step 5: Generate the CPO
Read `references/cpo-template.md` and fill in every section. Required fields
that must always be present (even if the analytics package isn't in the
knowledge base):

- **Complexity** — from Step 2
- **Data Confidence** — `session-tagged`, `estimated`, or `mixed`
- **Pattern Tags** — on every effective and ineffective pattern entry

### Step 6: Name and deliver
Filename convention: `CPO_###_Project_Name.md`

The number should follow the user's existing sequence. If unknown, ask.
Deliver as a downloadable markdown file.

## What Makes a Good CPO

The most valuable CPOs have:
- **Specific, falsifiable pattern descriptions** — not "communication was good"
  but "restating the constraint at session start prevented scope drift in S3-S5"
- **Root causes on ineffective patterns** — the `→ because` format forces
  actual analysis, not just listing what went wrong
- **Honest data confidence** — estimated metrics are fine; unlabeled guesses
  are not
- **Session map that tells a story** — the arc of the project should be
  readable from the session map alone

## Reference Files

- `references/cpo-template.md` — The v2.1 template to fill in
- `references/pattern-tags.md` — Controlled vocabulary for pattern tagging
