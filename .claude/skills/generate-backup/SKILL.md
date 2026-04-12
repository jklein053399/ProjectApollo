---
name: generate-backup
description: Zip the entire working directory (excluding .git) and save to D:/Backups. Use when the user says "generate backup", "backup", or "back it up".
disable-model-invocation: true
effort: min
---

# Generate Backup — Local JIC Backup

Creates a timestamped zip of the entire project directory and saves it to `D:/Backups/`.

---

## Step 1: Create the backup

Run this command to zip the working directory, excluding `.git/`:

```bash
PROJ_NAME=$(basename "$(pwd)")
DATESTAMP=$(date +%d-%m-%y)
DEST="D:/Backups/${PROJ_NAME}-${DATESTAMP}.zip"

# Remove existing backup for today if re-running
rm -f "$DEST"

# Zip everything except .git
cd "$(pwd)" && 7z a -tzip -xr!.git "$DEST" . || zip -r "$DEST" . -x ".git/*"
```

If neither `7z` nor `zip` is available, fall back to PowerShell:

```bash
PROJ_NAME=$(basename "$(pwd)")
DATESTAMP=$(date +%d-%m-%y)
DEST="D:/Backups/${PROJ_NAME}-${DATESTAMP}.zip"
rm -f "$DEST"
powershell -Command "Get-ChildItem -Path '.' -Exclude '.git' | Compress-Archive -DestinationPath '$DEST' -Force"
```

---

## Step 2: Verify

Run `ls -lh "$DEST"` to confirm the file was created and report the size to the user.

---

## Rules

- ALWAYS exclude `.git/` — everything else is included (including `.live-references/`, untracked files, outputs, etc.)
- Filename format: `<projectName>-<dd-mm-yy>.zip` (e.g., `BMSDatabase-06-04-26.zip`)
- If a backup for today already exists, overwrite it (re-running means the user wants a fresh one)
- Do NOT prompt the user for confirmation — just run it
- Report the final path and file size when done
