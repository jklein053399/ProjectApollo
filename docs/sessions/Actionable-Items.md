# Actionable Items

Rolling priority list maintained across sessions. Items flow: Priority → in-progress → Completed Archive. Parked items are deferred pending dependencies.

## Priority (Session 10)

1. **First real endpoint — T0 keyword dispatcher + `/dispatch` route.** First Apollo behavior beyond `/health`. Validates the tool-first architecture before LLM fallback layers.
2. **Reconcile `deploy/apollo.service` template with reality.** Template assumes user `apollo` at `/opt/apollo` with `NoNewPrivileges` + `ProtectSystem=strict`. Actual deployed unit uses `cypherklein` at `/home/cypherklein/apollo` with no hardening. Either update the template or document divergence as intentional.
3. **Refresh `.claude-config/PROJECT_CONTEXT.md`.** Last updated S5 (2026-03-18) — status still "Pre-Build", session history ends at S5. Fold in S6–S9.

## Parked

0. **Decide fate of remaining untracked work** (flagged 2026-06-09): `blender/` (incl. `.blend1`–`.blend20` backup files — gitignore those at minimum if ever committed), `docs/Apollo_AMP_Spec.md`, `docs/Apollo_Cyberdeck_Enclosure_Spec.md`, `.claude/settings.local.json`, `.claude/worktrees/`. Options: commit, gitignore, or archive elsewhere. `scad/` was gitignored same day per user decision — CAD stays local-only.
1. **STT on device** — `faster-whisper` install, mic capture via `pyaudio` or similar, basic `/transcribe` endpoint. Larger scope; Pi 5 performance validation involved. Queue after dispatcher exists.
2. **Clarify `blender/LaptopCyberdeck.blend` direction** — newest CAD artifact (2026-05-14→17), undocumented. Form-factor rethink or side exploration? Decision gates further enclosure work. Related cleanup candidates: leftover worktree `claude/zealous-mcnulty-ab2cb4` + `.claude/worktrees/`.
3. **Halo glasses integration** — awaiting hardware.
4. **ESP32 ring (BLE trigger)** — awaiting hardware + Bluetooth stack decisions.
5. **Overlayfs read-only root** — Session 5 integration-risk mitigation #6 (SD/NVMe corruption protection). Defer until pipelines are working; premature hardening otherwise.
6. **Combined USB audio device** — Session 5 integration-risk mitigation #5 (audio clock drift). Defer until audio I/O is being built.
7. **Claude Code as T3 dispatch tier (cloud escape hatch).** Install `@anthropic-ai/claude-code` on the Core and wire it in as the 4th tier in the T0 → T1 Sonnet → T2 Opus → T3 Claude Code dispatch chain, for intents the classifier/LLMs can't resolve. Adds agentic fallback without breaking offline-first (Layers 1–2 stay local). Requires T0 keyword dispatcher + T0.5 classifier working first to avoid expensive fall-through. Two other interpretations considered and rejected: (a) Claude Code as primary Cyberdeck UI — breaks offline-first, and (c) Claude Code as orthogonal dev/admin terminal — fine but not Apollo-architectural.

## Completed Archive

| Date | Item | Notes |
|------|------|-------|
| 2026-04-12 | Pi 5 NVMe boot migration | `rpi-clone nvme0n1`; `BOOT_ORDER=0xf416`; SD retained as passive fallback |
| 2026-04-12 | FastAPI skeleton deployed | `/home/cypherklein/apollo/`, `apollo.service` systemd unit, auto-starts at boot |
| 2026-04-12 | `/health` endpoint returns 200 after cold reboot | Session 7 done-when criteria met |
| 2026-04-12 | Initial repo commit + GitHub remote | `d9ba644`; `jklein053399/ProjectApollo` main branch |
| 2026-06-09 | Deploy workflow: scp → git pull | `~/apollo` converted in-place to git checkout; `deploy/deploy.sh`; loop proven with v0.1.1 |
| 2026-06-09 | SSH key auth Windows→Pi + `ssh cyberdeck` alias | ed25519; CRLF-pipe and Windows-ACL gotchas solved; capital-K trap engineered away |
| 2026-06-09 | Pi login password recovered & reset | auth-log forensics found the accepted attempt; reset to a known-to-Jacob password, recorded nowhere |
| 2026-06-09 | `scad/` gitignored per user decision | CAD stays local-only; blender/ + spec docs decision parked (item 0) |
