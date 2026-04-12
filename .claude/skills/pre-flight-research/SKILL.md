---
name: pre-flight-research
description: >
  Research before executing setup, install, or configuration commands. Use this
  skill BEFORE running any install command (npm, pip, brew, apt), configuring an
  MCP server, setting up API authentication, connecting to a third-party service,
  or modifying config files for external tools. Also trigger MID-CONVERSATION
  when two consecutive commands have failed on the same setup task — this is the
  assume-fail-guess-repeat anti-pattern and requires a mandatory research pause.
  Trigger on phrases like "set up", "install", "configure", "connect to",
  "add MCP server", "set up auth", or any task where Claude is about to provide
  a terminal command involving an external package or service. Do NOT trigger for
  internal code logic, git operations, file manipulation, or tasks where Claude
  is writing application code rather than installing or configuring dependencies.
---

# Pre-Flight Research

## Why This Exists

Setup and configuration tasks are where training data is most dangerous. Package
names get deprecated, API endpoints change, auth methods rotate, and config
syntax varies across versions — but Claude's training data still contains the
old information and treats it as current. The result is a specific anti-pattern:

```
Claude suggests a command → it fails
Claude guesses a variation → it also fails
Claude tries another variation → still fails
User: "Should we take a step back and do some research?"
Claude researches → finds the correct answer in 60 seconds
```

This skill eliminates the guessing loop by requiring verification *before* the
first command, not after the third failure.

## When to Run Pre-Flight Research

### Before execution (proactive)

Run the research step before ANY of these actions:

- **Package installation** — `npm install`, `pip install`, `brew install`, `apt install`, `cargo install`, or any package manager command
- **MCP server setup** — `claude mcp add`, editing MCP config files, connecting new servers
- **API authentication** — configuring tokens, OAuth flows, API keys for a service
- **Third-party service connection** — anything that reaches outside the local project
- **Config file creation** — JSON/YAML/TOML configs for tools Claude didn't author
- **Any command the user will run in their terminal** that involves an external dependency

### Mid-conversation (reactive — the Two-Failure Rule)

If Claude has suggested two commands or configurations that both failed on the
same setup task:

1. **Stop.** Do not suggest a third variation.
2. **Name the pattern.** "I've given you two approaches that didn't work. Before I guess again, let me research the current correct method."
3. **Research.** See the research checklist below.
4. **Present findings** — including what was wrong with previous attempts.
5. **Get confirmation** before executing the corrected approach.

One failure is informative. Two consecutive failures on a setup task means the
underlying assumptions are wrong, not the syntax.

### Do NOT trigger for

- Writing application code, business logic, or algorithms
- Standard git operations (`commit`, `push`, `pull`, `branch`)
- Local file operations (`mkdir`, `cp`, `mv`, `cat`)
- Commands Claude has already verified in this session
- Tools the user has confirmed are installed and working

## The Research Checklist

Scale research depth to task complexity:

### Quick check (simple installs, well-known packages)
- Verify the package exists under this exact name (check the registry)
- Confirm the install command for the user's platform
- ~30 seconds

### Standard check (integrations, configs, API setup)
- Search for current official documentation from the tool vendor
- Verify the recommended installation method (not a blog post from 2024)
- Check platform-specific notes (Windows / macOS / Linux)
- Confirm authentication method currently supported
- Note any deprecation notices or breaking changes
- ~1-2 minutes

### Deep check (unfamiliar tools, complex integrations, recent ecosystem changes)
- All of the above, plus:
- Cross-reference multiple sources
- Check for version-specific compatibility
- Look for community reports of working configurations
- ~2-3 minutes

## How to Present Findings

After research, present a verified plan before executing:

**Quick check result:**
> "Confirmed — `package-name` is current on npm. Here's the install command
> for your setup: [command]. Running it now."

**Standard check result:**
> "I checked the current docs for [tool]. Here's what I found:
> - The recommended install method is [X] (not [Y], which is deprecated)
> - Authentication requires [specific method]
> - On Windows, there's a known issue with [thing] — here's the workaround
>
> Ready to proceed with this approach?"

**After the Two-Failure Rule triggered:**
> "I researched this properly. The issue with my previous suggestions was
> [specific root cause]. The current correct approach is [X], verified
> against [source]. Here's the plan: [steps]. Confirm?"

## What This Doesn't Replace

This skill is adjacent to but distinct from `assumption-check`:

- **assumption-check** fires before implementation of features — it catches
  design assumptions ("does this API return timestamps in ISO format?")
- **pre-flight-research** fires before execution of setup commands — it catches
  stale training data ("does this package still exist under this name?")

Both can fire in the same session. assumption-check governs what you build;
pre-flight-research governs what you install and configure.

This skill also does not slow down coding tasks. Writing a Python function,
refactoring a module, designing a data model — none of these trigger research.
The trigger is specifically external dependencies where the landscape changes
faster than training data.

---

For real examples of the anti-pattern this skill prevents, including specific
deprecated packages and failed auth flows, read `references/failure-cases.md`.
