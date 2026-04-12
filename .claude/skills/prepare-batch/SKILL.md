---
name: prepare-batch
description: Prepare batch operations for the Compendium of Existence vault. Knows all vault conventions, YAML schemas, templates, and domain taxonomy — skips exploration and jumps straight to building work orders for /create-sub-agents. Use when planning any bulk vault operation.
argument-hint: [tier/task description, e.g. "Tier 2 add sub-domains to Physics" or "Tier 3 base roots for all domains"]
allowed-tools: Read, Glob, Grep, Bash, Agent
---

# Prepare Batch

Prepare batch work orders for the Compendium of Existence vault. This skill contains all vault conventions, schemas, and structural knowledge — eliminating the need to read templates, architecture docs, or example files before planning work.

**After preparing work orders, hand off to `/create-sub-agents` for dispatch.**

---

## Vault Structure (Baked-In)

```
Compendium-of-Existence/
├── _Meta/                    # Docs, schemas, build specs
├── _Templates/               # Note templates (reference only — don't modify)
├── _MOC/                     # One MOC per domain (e.g. _MOC/Physics.md)
├── Mathematics/              # Flat folder per domain — all notes inside
├── Building Automation/
├── Physics/
└── ...
```

**Rules:**
- Every domain gets one top-level folder + one MOC in `_MOC/`
- All sub-domain and base root notes live FLAT inside the domain folder
- Never create sub-folders inside domain folders
- `Directory.md` at vault root links to real pages only

---

## YAML Schemas (Baked-In)

### Domain MOC (`_MOC/DomainName.md`)
```yaml
type: domain-moc
name: Domain Name
domain: Domain Name
aliases: []
tags:
  - domain-tag
  - domain-moc
  - seeded          # stub | seeded | complete
created: YYYY-MM-DD
status: seeded      # stub | seeded | complete
summary: "1-2 sentence description"
related_domains:
  - "[[Other Domain]]"
```

### Sub-Domain (`DomainName/SubDomainName.md`)
```yaml
type: sub-domain
name: Sub-Domain Name
domain: Domain Name
parent: "[[Domain Name]]"
depth: 1
tags:
  - domain-tag
  - sub-domain
  - seeded
created: YYYY-MM-DD
status: seeded
summary: "1-2 sentence description"
children: []
related: []
```

### Base Root (`DomainName/ConceptName.md`)
```yaml
type: base-root
name: Concept Name
domain: Domain Name
parent: "[[Parent Sub-Domain]]"
tags:
  - domain-tag
  - base-root
  - seeded
created: YYYY-MM-DD
status: seeded
summary: "1-2 sentence description"
builds_into: []
external_sources: []
```

---

## Note Section Templates (Baked-In)

### Domain MOC sections (in order):
1. `# Domain Name`
2. `> [!summary] Overview` — 600-1000 words
3. `## Sub-Domains` — hub table with [[wiki-links]]
4. `## Base Roots` — links to foundational concepts
5. `## Cross-Domain Connections` — links with rationale
6. `## Deep Links` — [[ghost links]] to concepts without pages
7. `## Notes & Pipeline Status`

### Sub-Domain sections (in order):
1. `# Sub-Domain Name`
2. `> [!summary] Overview` — 600-1000 words
3. `## Key Concepts` — with [[wiki-links]]
4. `## Children` — child notes
5. `## Related` — lateral links
6. `## Notable Figures` — real names and dates
7. `## Foundational Texts / References`
8. `## Deep Links`
9. `## Notes & Pipeline Status`

### Base Root sections (in order):
1. `# Concept Name`
2. `> [!abstract] Definition` — precise definition
3. `## Why It's a Base Root`
4. `## Core Properties / Characteristics`
5. `## Builds Into` — what's constructed from this root
6. `## Appears In` — cross-domain appearances
7. `## Examples`
8. `## References`
9. `## Deep Links`
10. `## Notes & Pipeline Status`

---

## Status Definitions (Baked-In)

| Status | Meaning |
|--------|---------|
| **stub** | YAML + skeleton sections only, no real content |
| **seeded** | 600-1000 words, hub tables, wiki-links, Notable Figures, Deep Links |
| **complete** | Fully reviewed, all links resolved, external sources populated |

---

## Build Tiers (Baked-In)

| Tier | Task | Description |
|------|------|-------------|
| 1 | Deepen stubs | Upgrade expanded stubs to seeded (content, hub tables, links) |
| 2 | Add sub-domains | Add missing sub-domains (target 8-15 per domain) |
| 3 | Add base roots | Create terminal foundational concepts (~6 per domain) |
| 4 | Add missing domains | Scaffold entirely new domains (MOC + sub-domains) |
| 5 | Semantic tags | Add tag ontology to YAML frontmatter |
| 6 | Contributor docs | CONTRIBUTING.md, validation docs |

---

## Current Vault State

To get current state, run these quick checks (NOT full exploration):

```
# Count domains and files
ls _MOC/ | wc -l
find . -name "*.md" -not -path "./_Meta/*" -not -path "./_Templates/*" | wc -l

# Check a domain's status
head -15 "_MOC/Physics.md"  # read YAML to see status

# List what exists in a domain folder
ls Physics/
```

**Known state as of 2026-04-01 (post Tier-1 batch):**
- 38 domain MOCs
- 3 seeded (deep): Mathematics, Building Automation, Botanical Sciences
- 35 deepened from stub → seeded via 25-agent batch
- ~150 sub-domain files (3 per domain)
- Base roots exist only in Mathematics and Building Automation
- `domain_taxonomy.json` in `_Meta/compendium-claude-code.zip` has full target taxonomy

---

## Preparing Work Orders

### Step 1: Identify Scope

Parse `$ARGUMENTS` to determine:
- Which tier of work
- Which domains (or "all")
- What specific task

### Step 2: Discover Current State

Only read what's needed — don't explore the whole vault:
- For Tier 2 (add sub-domains): Read the MOC to see existing sub-domains, check taxonomy JSON for target list
- For Tier 3 (base roots): Check what base roots exist in domain folder, check taxonomy for needed ones
- For Tier 4 (new domains): Check which MOCs exist, compare to taxonomy

### Step 3: Build Agent Assignments

Divide work across agents (max 25):
- **1 domain per agent** for heavy work (creating 5+ files with real content)
- **2 domains per agent** for medium work (editing 4-8 existing files)
- **3 domains per agent** for light work (adding YAML fields, minor edits)

### Step 4: Generate Work Order Template

Each work order MUST include:
1. Exact file paths (absolute: `D:/Claude/Compendium-of-Existence/...`)
2. The YAML schema for the note type being created/edited
3. Section structure requirements
4. Content requirements (word count, wiki-links, etc.)
5. Constraints (no new folders, no Directory.md edits, preserve YAML)
6. Completion criteria

### Step 5: Cost Estimate + User Approval

Before handing to `/create-sub-agents`, present:
- Agent count and assignment table
- Estimated tokens per agent and total
- Estimated wall clock time
- Request explicit user approval

---

## Work Order Templates by Tier

### Tier 2: Add Sub-Domain
```
WORK ORDER — Agent [N]: [DOMAIN] — Add Sub-Domains

FILES TO CREATE:
- D:/Claude/Compendium-of-Existence/[Domain]/[NewSubDomain].md

FILE TO EDIT:
- D:/Claude/Compendium-of-Existence/_MOC/[Domain].md (add to hub table + children)

YAML (use this exact schema):
[paste sub-domain YAML from above]

SECTIONS (use this exact structure):
[paste sub-domain sections from above]

CONTENT: 600-1000 words, factually accurate, 5+ [[wiki-links]], Notable Figures with dates

CONSTRAINTS: No sub-folders. Flat in domain folder. Preserve MOC YAML structure when editing.
```

### Tier 3: Add Base Root
```
WORK ORDER — Agent [N]: [DOMAIN] — Add Base Roots

FILES TO CREATE:
- D:/Claude/Compendium-of-Existence/[Domain]/[ConceptName].md

FILE TO EDIT:
- D:/Claude/Compendium-of-Existence/_MOC/[Domain].md (add to Base Roots section)

YAML (use this exact schema):
[paste base-root YAML from above]

SECTIONS (use this exact structure):
[paste base-root sections from above]

CONTENT: 400-700 words, precise definition, builds_into links, cross-domain appearances

CONSTRAINTS: No sub-folders. Parent must be an existing sub-domain.
```

### Tier 4: Scaffold New Domain
```
WORK ORDER — Agent [N]: [DOMAIN] — Scaffold New Domain

FILES TO CREATE:
- D:/Claude/Compendium-of-Existence/_MOC/[Domain].md
- D:/Claude/Compendium-of-Existence/[Domain]/[SubDomain1].md
- D:/Claude/Compendium-of-Existence/[Domain]/[SubDomain2].md
- D:/Claude/Compendium-of-Existence/[Domain]/[SubDomain3].md

Create the domain folder first: mkdir [Domain]

YAML schemas: [paste MOC + sub-domain schemas]
Section structures: [paste both section templates]

Phase 1 (stub): Create all files with YAML + skeleton sections, minimal content
Phase 2 (seed): Expand to 600-1000 words each — can be done same pass or separate

CONSTRAINTS: No sub-folders. Tags must include domain slug.
```

---

## Handoff to /create-sub-agents

After preparing work orders and receiving user approval, invoke `/create-sub-agents` with the prepared assignments. The work orders are already structured — `/create-sub-agents` just needs to dispatch them.
