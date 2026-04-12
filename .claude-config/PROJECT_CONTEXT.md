# PROJECT_CONTEXT.md — Project Apollo
> **Version:** 1.0  
> **Last Updated:** 2026-03-18 (Session 5)  
> **Project Type:** Hardware + Software — Personal Wearable AI Assistant  
> **Status:** Active — Design Complete, Branch Planned, Pre-Build

---

## Project Identity

**Name:** Project Apollo  
**Description:** A personal wearable computing system designed as a cyberpunk-inspired offline AI assistant. Three-unit system called CyberGear: Apollo Core (compute), Apollo Cyberdeck (user I/O), Apollo Glasses (camera + HUD). Voice-driven, tool-first architecture with local LLM fallback and cloud as last resort.  
**Owner:** Just a Man  
**Start Date:** 2026-03  
**Budget Ceiling:** $2,000  

---

## Current Goal

Create the **Branch Interim MVP** — a faster-to-test version of Apollo that uses off-the-shelf Brilliant Labs Halo glasses, web-based UI, phone-as-camera for video, and simplified dispatch. Goal is to reach user testing months sooner than the original custom-build spec, then use field data to inform the eventual custom Glasses build.

---

## Success Criteria

1. Working voice loop: ring press → STT → keyword dispatch → pipeline tool → TTS response
2. Three core pipelines functional: Conductor, Ticket Man, Einstein
3. HUD feedback visible on Halo glasses for all active pipelines
4. Cyberdeck web UI rendering in Chromium kiosk on Pi 5 with staged layouts
5. All units communicating over Core's private WiFi AP
6. System operates fully offline for Layers 1 and 2 (tool + local LLM)

---

## Key Constraints

- **Offline-first:** System must work without internet for core pipelines
- **Accuracy over speed:** Prefer better STT/LLM accuracy even at cost of latency
- **Adaptability over optimization:** Design for future-proofing, not current-state optimization
- **Tool-first:** Every pipeline runs a dedicated Python tool before touching the LLM
- **Budget:** $2,000 ceiling for MVP hardware

---

## Architecture Summary

### Hardware (CyberGear)
| Unit | Hardware | Role |
|------|----------|------|
| Apollo Core | GEEKOM A9 Max (Ryzen AI 9 HX 370, 64GB DDR5, 512GB NVMe) | Compute + WiFi AP. All AI processing. |
| Apollo Cyberdeck | Raspberry Pi 5 (8GB) + 7" touchscreen + mic + speaker | Wrist-mounted I/O hub. Web UI via Chromium kiosk. |
| Apollo Glasses (interim) | Brilliant Labs Halo ($299, open-source) + clip-on camera | HUD display + Imager stills. BLE → Cyberdeck relay → Core. |
| Ring | ESP32 BLE breadboard button | Universal STT trigger. |
| Phone | User's phone on Core WiFi | VideoForge capture + internet gateway. |

### Software Stack
| Component | Choice | Notes |
|-----------|--------|-------|
| Core OS | Ubuntu 24.04 LTS | On GEEKOM A9 Max |
| API Server | FastAPI + uvicorn | Serves all pipelines AND the web UI |
| Resident LLM | Qwen 2.5 14B (Q4_K_M) | Always loaded. ~10GB RAM. ~7 tok/s on HX 370. |
| Code Specialist | DeepSeek Coder V2 16B | On-demand via Ollama |
| Vision Specialist | LLaVA 13B / Qwen2-VL 7B | On-demand via Ollama |
| Inference (resident) | llama-server (llama.cpp) | Direct serving, lower overhead than Ollama |
| Inference (specialists) | Ollama | Model management for on-demand swaps |
| STT | faster-whisper | Replaces Vosk. 3x faster, much better accuracy. |
| TTS | Kokoro-82M | Replaces Piper. Better quality, active development. |
| Dispatcher | Keyword pattern matcher + LLM fallback | Replaces custom neural net. Tool-first pattern. |
| Cyberdeck UI | Svelte + Chromium kiosk | Replaces Kivy/PyQt5 Python GUI |
| Cyberdeck audio | Thin Python daemon (pyaudio/aplay) | Hardware audio only; UI is web-based |
| Web search | TBD (SearXNG vs simpler) | Open question |
| Calendar | TBD (local SQLite vs phone bridge) | Open question |

### Seven Pipelines
| Pipeline | Layer 1 (Tool) | Layer 2 (LLM) | Layer 3 (Cloud) |
|----------|---------------|----------------|-----------------|
| Conductor | Rhythm Engine → formatter → TTS | — | — |
| Ticket Man | STT → raw text → Rhythm Engine inbox | — | — |
| Einstein | sympy, math, pint, web search | Resident 14B | Cloud API |
| Voice Notes | STT → keyword parser → checklist/calendar | Resident 14B | Cloud API |
| Imager | CLIP / MobileNet classifier | Vision LLM | Cloud API |
| VideoForge | FFmpeg / MoviePy (phone capture) | — | — |
| CodeForge | — (LLM is primary) | Resident 14B / DeepSeek Coder | Cloud API |

---

## Design Principles (Locked)

1. **Tool-first, LLM-fallback, cloud-last** — deterministic tools before probabilistic models
2. **Accuracy over speed** — better results at slower pace preferred
3. **Adaptability over optimization** — future-proof over current-state tuned
4. **Input-agnostic, skinnable** — UI actions are abstractions, visual layer is CSS themes
5. **Cyberdeck is transitional** — becomes secondary screen as Glasses evolve
6. **Function first, aesthetic later** — CP2077 vision is endgame, not MVP
7. **Vertical slice over component perfection** — working cross-system loop before perfecting parts
8. **User-modifiable when possible** — low priority but bonus (keyword map is a text file, CSS themes are swappable)

---

## Known Integration Risks & Mitigations

| # | Risk | Fix | Status |
|---|------|-----|--------|
| 1 | Pi 5 WiFi+BLE shared antenna breaks | USB BLE dongle, disable onboard BT | Planned — mandatory |
| 2 | LLM ~7 tok/s, 30-45s voice-to-voice | Tool-first routing, consider 7B model | Accepted |
| 3 | BLE to glasses ~65KB/s ceiling | Text-only HUD, incremental updates | Designed for |
| 4 | Chromium kiosk memory leaks | Daily reboot, tmpfs, systemd restart | Planned |
| 5 | Audio clock drift (separate USB devices) | Single combined USB audio device | Planned — mandatory |
| 6 | SD/NVMe corruption from power loss | Overlayfs read-only filesystem | Planned — mandatory |
| 7 | WebSocket drops | Exponential backoff, heartbeats, replay | To implement |
| 8 | Camera glasses social friction | Clip-on removable camera, no fix for stigma | Accepted |

---

## Document Inventory

### Authoritative Specs
| Document | Scope | Version |
|----------|-------|---------|
| Project_Apollo_Orion_MVP_Beta2.docx | Parent MVP — unified system view | Rev. Beta-2 |
| Apollo_Core_Revised_Addendum.docx | Core subsystem | Session 2, Rev. Beta-2 |
| Apollo_Cyberdeck_Revised_Addendum.docx | Cyberdeck subsystem | Session 3, Rev. Beta-2 |
| Apollo_Glasses_Revised_Addendum.docx | Glasses subsystem (original custom build) | Session 4, Rev. Beta-2 |

### Working Documents
| Document | Purpose |
|----------|---------|
| Apollo_BOM_Purchasing.xlsx | Purchasing checklist with links and budget |
| Apollo_Discussion_Log_Session[1-5].md | Session-by-session decision records |
| PROJECT_CORE.md | Framework governance (universal) |
| PROJECT_CONTEXT.md | This file — project-specific context |

### Pending
| Document | Status |
|----------|--------|
| Project_Apollo_Orion_MVP_Branch_Interim.docx | To be created next session — captures all branch pivots |

### Superseded (kept as reference)
| Document | Superseded By |
|----------|---------------|
| Project_Apollo_Orion_MVP_Beta.docx | Beta2 |
| Apollo_Project_Overview.docx | Beta2 + addenda |
| Apollo_CyberGlasses_Addendum.docx | Glasses Revised Addendum |
| Apollo_Glasses_MVP_Addendum.docx | Glasses Revised Addendum |
| Apollo_Orion_Work_Breakdown.docx | Addenda phase roadmaps |

---

## Session History

| Session | Date | Focus | Key Outcome |
|---------|------|-------|-------------|
| S1 | 2026-03 | Initial project setup | Project structure, first MVP spec, hardware selection |
| S2 | 2026-03-15 | Apollo Core deep dive | Hardware upgraded to GEEKOM A9 Max, tool-first architecture locked, 3-model LLM stack, 7 pipelines defined, wake words eliminated |
| S3 | 2026-03-16 | Apollo Cyberdeck review | Full UI/UX locked: 3 templates, staged layouts, hub-and-spoke, dual trigger, mute rule, 4-tier errors, 9-gap analysis resolved |
| S4 | 2026-03 | Apollo Glasses review | Glasses role expanded (dual capture, HUD per pipeline), ring state machine locked, VideoForge changed to H.264, push-only HUD model |
| S5 | 2026-03-18 | Doc consolidation + architectural pivot | Created Core+Cyberdeck addenda, updated MVP, created BOM. Major branch: Halo interim glasses, web UI, faster-whisper, keyword dispatcher. Integration risk research across 4 domains. |

---

## Next Session Plan

1. **Deep dives** into each of the 8 integration risks (one per topic if needed)
2. **Create branch document:** Project_Apollo_Orion_MVP_Branch_Interim.docx
3. **Resolve open questions:** Ollama vs llama-server hybrid, SearXNG vs simpler search, local calendar vs phone bridge
4. **Update BOM** to reflect branch changes (add Halo, clip-on camera, USB BLE dongle, USB audio adapter; remove custom Glasses parts)

---

## Budget Status

| Category | Estimated | Notes |
|----------|-----------|-------|
| Original MVP (all phases) | $1,529 | Per BOM spreadsheet |
| Branch changes (net) | ~+$175 | +$299 Halo, +$15 clip-on cam, +$8 BLE dongle, +$10 USB audio; −$132 custom Glasses parts, −$25 beam splitter/OLED |
| Revised estimate | ~$1,704 | Before optional items |
| Optional items | $165 | LTE dongle, portable power, wide camera |
| Budget ceiling | $2,000 | ~$296 remaining for iteration |

---
_End of PROJECT_CONTEXT.md — Project Apollo_
