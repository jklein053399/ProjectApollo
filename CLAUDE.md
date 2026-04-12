# Project Apollo — Claude Code Entry Point

Read these files for full project context:
- `.claude-config/PROJECT_CORE.md` — Universal behavioral rules, session contracts, commands
- `.claude-config/PROJECT_CONTEXT.md` — Project-specific state, architecture, decisions, session history

## Code Conventions
- Python 3.11+, type hints on public functions
- FastAPI for all API endpoints
- Project source lives in `src/`
- Tests in `tests/`
- Use `venv` for virtual environments
- Target platform: Raspberry Pi 5 (aarch64) for Phase 1, GEEKOM A9 Max (x86_64) for Phase 4+
- Everything built on Pi migrates to GEEKOM via config change — keep platform-specific code isolated

## Build & Run
- `source venv/bin/activate` (when on Pi)
- `uvicorn src.main:app --host 0.0.0.0 --port 8000`
- Tests: `pytest tests/`
