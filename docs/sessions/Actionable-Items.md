# Actionable Items

Rolling priority list maintained across sessions. Items flow: Priority → in-progress → Completed Archive. Parked items are deferred pending dependencies.

## Priority (Session 8)

1. **Deploy workflow upgrade.** Replace `scp -r` with either `git pull` on the Pi or `rsync --exclude` from Windows. `scp` pulls stale `__pycache__` dirs and has no exclude support. Short, unblocks every code change after it. Recommend `git` — Pi can just pull `main`.
2. **Reconcile `deploy/apollo.service` template with reality.** Template assumes user `apollo` at `/opt/apollo` with `NoNewPrivileges` + `ProtectSystem=strict`. Actual deployed unit uses `cypherklein` at `/home/cypherklein/apollo` with no hardening. Either update the template or document divergence as intentional.
3. **First real endpoint — T0 keyword dispatcher + `/dispatch` route.** First Apollo behavior beyond `/health`. Validates the tool-first architecture before LLM fallback layers.

## Parked

1. **STT on device** — `faster-whisper` install, mic capture via `pyaudio` or similar, basic `/transcribe` endpoint. Larger scope; Pi 5 performance validation involved. Queue after dispatcher exists.
2. **SSH key auth on Pi** — currently password-only. Keys would let Claude run commands non-interactively from Windows (eliminating the `!` prefix interactive flow entirely). Low urgency, high quality-of-life.
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
