---
name: push-update
description: End-of-session housekeeping. Use when the user says "push update", "push an update", or is wrapping up a session. Surveys repo, generates session log, updates project context, updates actionable items, then commits and pushes.
disable-model-invocation: true
effort: max
---

# Push Update — End-of-Session Skill

This skill performs the full end-of-session housekeeping process. Execute ALL steps in order. Do not skip steps. Do not ask the user to do steps manually — do them yourself.

---

## Step 1: Survey the Repo

Understand what changed this session before doing anything else.

Run these in parallel:
- `git status` — see all modified, staged, and untracked files
- `git diff` — see unstaged changes
- `git diff --cached` — see staged changes
- `git log --oneline -20` — recent commit history
- `git branch -a` — current branch state
- `git log main..HEAD --oneline` (if not on main) — commits ahead of main

Read the current date from the system. All session documents use the format `YYYY-MM-DD`.

Summarize findings to the user:
- What files changed (grouped by area: tools/, knowledge-base/, rulesets/, references/, docs/, etc.)
- How many commits this session (if any already made)
- Current branch and its relationship to main

---

## Step 2: Confirm Branch Strategy

Based on the survey, recommend ONE of these strategies:
- **Direct to main** — small focused changes, no risk
- **Feature branch + merge** — larger feature work, merge to main before push
- **Feature branch only** — work in progress, not ready for main

Present your recommendation with reasoning. Wait for user confirmation before proceeding.

---

## Step 3: Update Project Context

Review what was learned and accomplished this session. Update as needed:

### Memories
Check `~/.claude/projects/C--Programs-BASKB-Pull-Repo/memory/MEMORY.md` and the memory files it references.
- **New memories**: Create files for any new project decisions, user feedback, reference pointers, or workflow preferences discovered this session
- **Updated memories**: Modify any memories that are now outdated based on this session's work
- **Stale memories**: Flag (but don't delete without asking) any memories that appear to be obsolete
- Follow the memory format: frontmatter (name, description, type) + content body
- Add new entries to MEMORY.md index

### CLAUDE.md
Read the project CLAUDE.md. If this session produced new conventions, critical paths, or rules that should persist, update it. Do NOT update CLAUDE.md for minor or temporary items — only for durable, cross-session conventions.

Tell the user what context updates you made and why.

---

## Step 4: Generate Session Log

Create or update TWO documents:

### 4a: Session Handoff (`docs/sessions/Handoff-{date}.md`)

If a handoff already exists for today, create `Handoff-{date}-B.md` (or `-C`, `-D`, etc.).

Follow this EXACT template:

```markdown
# Session Handoff — {date}

## What Was Accomplished

### Committed to {branch} ({short-hash})
1. **Item** — description
2. **Item** — description

### Key Discoveries
- Discovery with context
- Discovery with context

## Action Items for Next Session

### Priority
1. Item with enough context to pick up cold
2. Item with enough context to pick up cold

### Parked
1. Item — brief reason it's parked

## Branch State
- **main**: status
- **other branches**: status

## Files Changed This Session
| File | Change |
|------|--------|
| `path/to/file` | NEW / FIX / UPDATE — description |
```

### 4b: Work Report (`docs/sessions/Work-Report-{date}.md`)

If a work report already exists for today, UPDATE it by appending a new session section rather than overwriting.

Format: Narrative prose summary of the session. What was built, what was discovered, what was fixed. Include concrete numbers (commits, files, points, etc.). Group by logical topic, not chronological order. See existing Work Reports for style reference.

---

## Step 5: Update Actionable Items

Read `docs/sessions/Actionable-Items.md` and update it:

1. **Move completed items** — anything finished this session moves to the Completed Archive table at the bottom, with today's date and a brief note
2. **Add new items** — any new action items, quick wins, or parked items surfaced this session get added to their appropriate section
3. **Update existing items** — if progress was made on an item but it's not complete, update its description to reflect current state
4. **Reorder by priority** — ensure the most important next-session items are at the top

---

## Step 6: Commit and Push

Now that all documents are generated and updated:

1. **Stage files** — `git add` the specific files that changed (code + docs + context). Be explicit, don't use `git add -A`.
2. **Commit** — Write a clear commit message summarizing the session's work. Use the format:
   ```
   Summary line (what was accomplished)

   - Key item 1
   - Key item 2
   - Session log and project context updated
   ```
3. **Push** — Push to remote. If on a feature branch that was confirmed for merge in Step 2, merge to main first, then push main.
4. **Verify** — Run `git status` and `git log --oneline -3` to confirm clean state.

Report the final commit hash and branch state to the user.

---

## Rules

- NEVER skip the user confirmation in Step 2. Always wait for input.
- NEVER overwrite existing session documents. Append or create suffixed versions.
- NEVER use `git add -A` or `git add .` — always stage specific files.
- NEVER push to a remote branch without user confirmation from Step 2.
- If the session had no meaningful code changes (only discussion), say so and ask if the user still wants a session log. Context updates and actionable items should still be refreshed.
- Keep handoff documents factual and detailed enough that a cold reader can pick up the work. Include file paths, commit hashes, and specific technical details.
- Work reports are narrative — write them like a technical journal entry, not a bullet list.
