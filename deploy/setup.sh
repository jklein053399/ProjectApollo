#!/usr/bin/env bash
# Apollo Pi 5 Bootstrap Script
# Run as root on first boot: sudo bash setup.sh
# Idempotent — safe to re-run if interrupted.

set -euo pipefail

APOLLO_DIR="/opt/apollo"
APOLLO_USER="apollo"
APOLLO_HOSTNAME="apollo-cyberdeck"
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "=== Apollo Pi 5 Bootstrap ==="
echo "Source: $SCRIPT_DIR"
echo ""

# --- System packages ---
echo "[1/7] Updating system packages..."
apt update && apt upgrade -y

echo "[2/7] Installing dependencies..."
apt install -y python3 python3-venv python3-pip git build-essential curl

# --- System user ---
echo "[3/7] Creating apollo user..."
if ! id "$APOLLO_USER" &>/dev/null; then
    useradd --system --shell /usr/sbin/nologin --home-dir "$APOLLO_DIR" "$APOLLO_USER"
    echo "  Created user: $APOLLO_USER"
else
    echo "  User $APOLLO_USER already exists, skipping."
fi

# --- Project files ---
echo "[4/7] Copying project to $APOLLO_DIR..."
mkdir -p "$APOLLO_DIR"
rsync -a --exclude='venv' --exclude='node_modules' --exclude='.git' \
    --exclude='apollo_package' --exclude='cyberdeck-ui' \
    "$SCRIPT_DIR/" "$APOLLO_DIR/"
chown -R "$APOLLO_USER:$APOLLO_USER" "$APOLLO_DIR"

# --- Python venv ---
echo "[5/7] Setting up Python virtual environment..."
if [ ! -d "$APOLLO_DIR/venv" ]; then
    python3 -m venv "$APOLLO_DIR/venv"
fi
"$APOLLO_DIR/venv/bin/pip" install --upgrade pip
"$APOLLO_DIR/venv/bin/pip" install -r "$APOLLO_DIR/requirements.txt"

# --- systemd service ---
echo "[6/7] Installing systemd service..."
cp "$APOLLO_DIR/deploy/apollo.service" /etc/systemd/system/apollo.service
systemctl daemon-reload
systemctl enable apollo
echo "  Service enabled. Will start on next boot."

# --- Hostname ---
echo "[7/7] Setting hostname to $APOLLO_HOSTNAME..."
if [ "$(hostname)" != "$APOLLO_HOSTNAME" ]; then
    hostnamectl set-hostname "$APOLLO_HOSTNAME"
    echo "  Hostname set. Takes effect on next boot."
else
    echo "  Hostname already set, skipping."
fi

echo ""
echo "=== Bootstrap complete ==="
echo ""
echo "Next steps:"
echo "  1. Reboot:          sudo reboot"
echo "  2. SSH back in:     ssh apollo-cyberdeck.local"
echo "  3. Verify service:  curl http://localhost:8000/health"
echo "  4. Check logs:      journalctl -u apollo -f"
