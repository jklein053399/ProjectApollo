# Apollo Pi 5 — OS Image Configuration

## Boot Media Options

### Option A: USB Drive Boot (immediate, no adapter needed)
The Pi 5 can boot directly from a USB drive. This is a good interim option if you have a 32GB USB stick available.

1. **On your Windows PC**, download [Raspberry Pi Imager](https://www.raspberrypi.com/software/)
2. Plug in the 32GB USB drive
3. Open Imager → choose OS → choose the USB drive → write (settings below)
4. Plug the USB into a **blue USB 3.0 port** on the Pi 5
5. Power on — Pi 5 checks USB boot by default if no SD card is present

**Note:** USB boot is slower than NVMe but perfectly fine for development. You'll migrate to NVMe later.

### Option B: microSD Card
If you have a microSD but no adapter, you **cannot format it from the Pi itself** without already having a bootable OS. The Pi has no built-in firmware UI or recovery mode that lets you format media — it needs a working OS image to boot.

**You need a microSD-to-USB adapter ($3-5) or a PC with an SD slot to flash the card.** If the card has an old OS on it, the Pi might boot from it, but it's unpredictable — better to flash a clean image.

### Option C: NVMe (target setup, needs M.2 HAT)
Once you have the M.2 HAT + NVMe SSD from Wave 1, flash directly to NVMe via Imager (it shows up as a USB mass storage device when the HAT is connected).

---

## Raspberry Pi Imager Settings

**OS:** Raspberry Pi OS Lite (64-bit) — Debian Bookworm
*(No desktop — we run Chromium kiosk separately when the display is connected)*

**Edit Settings (gear icon):**

| Setting | Value |
|---------|-------|
| Hostname | `apollo-cyberdeck` |
| Enable SSH | Yes — password authentication (switch to key-based after first login) |
| Username | `apollo` |
| Password | *(your choice — change after first login)* |
| WiFi SSID | *(your home network)* |
| WiFi Password | *(your WiFi password)* |
| WiFi Country | `US` |
| Locale | `en_US.UTF-8` |
| Timezone | *(your timezone)* |

---

## After First Boot

1. Find the Pi on your network: `ping apollo-cyberdeck.local` (or check router DHCP leases)
2. SSH in: `ssh apollo@apollo-cyberdeck.local`
3. Run the bootstrap script: `sudo bash /path/to/setup.sh`
4. Reboot and verify: `curl http://localhost:8000/health`

## NVMe Migration (when M.2 HAT arrives)

1. Flash a fresh image to NVMe via Raspberry Pi Imager (same settings above)
2. Install the M.2 HAT, seat the NVMe
3. Update boot order to prefer NVMe: `sudo raspi-config` → Advanced → Boot Order → NVMe
4. Reboot — Pi boots from NVMe
5. Re-run `setup.sh` on the NVMe install
6. Remove the USB/SD card — no longer needed
