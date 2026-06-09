#!/usr/bin/env bash
# Apollo deploy — run ON the Pi:  bash ~/apollo/deploy/deploy.sh
# (or from Windows:  ssh cypherklein@<pi-ip> "bash ~/apollo/deploy/deploy.sh")
set -euo pipefail

cd "$(dirname "$0")/.."

git pull --ff-only

# Reinstall deps only when requirements.txt changed in this pull
if git diff --name-only 'HEAD@{1}' HEAD 2>/dev/null | grep -q '^requirements.txt$'; then
    venv/bin/pip install -r requirements.txt
fi

sudo systemctl restart apollo
curl -sf --retry 5 --retry-connrefused --retry-delay 1 localhost:8000/health
echo
