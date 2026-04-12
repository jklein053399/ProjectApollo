---
name: context-handoff
description: >
  Manage context at session end to ensure continuity into the next session.
  Use this skill whenever a session is winding down and work will continue —
  meaningful progress was made, decisions were taken, or a clear next step
  exists. Trigger when: the user signals they're done for now, a natural
  stopping point is reached, a milestone is completed, or the project status
  shifts to Paused or Archived. Four distinct behaviors: (1) session handoff
  summary, (2) PROJECT_CONTEXT.md update offer, (3) CPO generation suggestion
  at project close, (4) session tag reminder on first session after setup.
  Also flag stale or conflicting knowledge base files when detected. Do NOT
  trigger after trivial sessions — quick questions, minor fixes, or
  informational exchanges with no decisions or deliverables.
---

# Context Handoff

## Why This Exists

`context-loss` is a recurring friction point across medium and high complexity
projects — not always the loudest anti-pattern, but consistently present.
The cause is almost always the same: a session ends cleanly in the moment but
leaves no trail for the next one. The next session starts by reconstructing
what was already known, which wastes time and introduces gaps.

This skill handles the end-of-session behaviors that prevent that loss.
It's the counterpart to `session-contract` — contract opens the session,
handoff closes it.

---

## Behavior 1: Session Handoff Summary

**When:** A session ends with work that will continue in a future session.

**What to produce:** A brief summary covering four things —
1. What was accomplished this session
2. What's still pending
3. Any decisions that need to be made next
4. Recommended scope for the next session

**Delivery:** Offer it proactively — don't wait to be asked.

> *"Before we close — want a quick handoff summary so the next session
> picks up clean?"*

For complex sessions or long pauses, offer a `WHERE-WE-LEFT-OFF.md` file
instead of an inline summary. Use judgment: if the session covered multiple
decisions, scope changes, or unresolved questions, the file is the right
call.

**Format for inline summary:**
```
Done: [what was completed]
Pending: [what's still open]
Decisions needed: [anything unresolved that will block next session]
Next session: [recommended scope — one sentence]
```

---

## Behavior 2: PROJECT_CONTEXT.md Update

**When:** The session produced meaningful progress — new decisions, scope
changes, completed milestones, or status shifts.

**What to offer:**

> *"We made some progress this session. Want me to generate an updated
> PROJECT_CONTEXT.md with the new session log entry and
> [decisions / status change / goal update]?"*

**When not to offer:** Trivial sessions — quick questions, minor fixes,
informational exchanges. If nothing in PROJECT_CONTEXT.md would change,
don't ask.

**If the user agrees:** Produce the updated file for download (web) or
write it directly (Claude Code). Include:
- New session log entry in the format `[YYYY-MM-DD] S# — [focus] — [outcome]`
- Any updated fields: Current Goal, Phase, Decision Log, Success Criteria

---

## Behavior 3: CPO Generation Suggestion

**When:** Signals that a project is closing or pausing —
- User updates status to Paused or Archived
- User says "I think we're done" / "wrapping up" / "that's it for this project"
- Final deliverables are being completed
- User explicitly stops work with no stated intention to continue

**What to say:**

> *"This looks like a good stopping point. Want me to run
> `Generate Project Overview` before we close out?"*

Don't push if the user declines. One suggestion, one time.

---

## Behavior 4: Session Tag Reminder

**When:** First session after PROJECT_CONTEXT.md setup is complete, if the
user hasn't already been using session tags.

**What to say — once:**

> *"By the way — if you want to log sessions as we go, you can drop a
> `Session log: S# — focus — outcome` at the end of any chat. Makes the
> CPO more accurate later."*

**After the initial mention:** Only remind again if the session history
in PROJECT_CONTEXT.md hasn't been updated in 3+ sessions. Don't nag.

---

## Behavior 5: Knowledge Base Hygiene

**When:** Stale, conflicting, or misnamed files are detected in the
knowledge base — at any point in the session, not just at close.

**Flag stale files:**
> *"Heads up — [filename] looks like it's been superseded by [newer file].
> Worth removing to keep the KB clean."*

**Flag conflicts:**
> *"The session history in PROJECT_CONTEXT.md doesn't match what we've
> covered in this conversation. Want me to reconcile them?"*

**Flag naming issues:** Files should have clear, descriptive names. If a
file is named ambiguously (e.g., `notes.md`, `draft2.md`, `temp.md`),
flag it when it comes up — don't let the KB accumulate noise.

---

## Behavior Order at Session End

When multiple behaviors apply at the same session close, sequence them:

1. **Handoff summary** — immediate, captures the session while it's fresh
2. **PROJECT_CONTEXT.md update** — follows naturally from the summary
3. **CPO suggestion** — only if project is actually closing
4. **Session tag reminder** — only on first session, lightweight

Don't stack all of them as separate prompts. Roll adjacent ones together
where natural — the handoff summary and PROJECT_CONTEXT.md update are
often one conversation.

---

## What This Replaces

This skill replaces PROJECT_CORE Section 4 (Context Management Rules).
It's the end-of-session counterpart to `session-contract` (start of
session) and `scope-guard` (mid-session). Together the three skills cover
the full session lifecycle: open → protect → close.
