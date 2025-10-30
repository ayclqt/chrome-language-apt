#!/bin/bash

# Check if running as root
[ "$EUID" -ne 0 ] && { echo "Please run as root or with sudo"; exit 1; }

LANGUAGE_CODE="${1:-vi_VN}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FIXCHROME_SOURCE="$SCRIPT_DIR/fixchrome"
FIXCHROME_DEST="/usr/local/bin/fixchrome"
APT_HOOK_PATH="/etc/apt/apt.conf.d/99chrome-locale"
DOWNLOAD_URL="https://github.com/ayclqt/chrome-language-apt/releases/latest/download"

echo "Installing fixchrome with default language: $LANGUAGE_CODE"

# Check if fixchrome exists in current directory, else download it
cp "$(dirname "$0")/fixchrome" "$FIXCHROME_DEST" 2>/dev/null || {echo "fixchrome not found. Downloading..." && curl -fsSL "$DOWNLOAD_URL/fixchrome" -o "$FIXCHROME_DEST" && echo "Download complete!"} || { echo "Error: Failed to get fixchrome script"; exit 1; }

# Replace default language code
sed -i "s/LANGUAGE_CODE=\"\${1:-[^}]*}\"/LANGUAGE_CODE=\"\${1:-$LANGUAGE_CODE}\"/" "$FIXCHROME_DEST"

# Set executable permission
chmod +x "$FIXCHROME_DEST" && echo "Installed $FIXCHROME_DEST. Default language: $LANGUAGE_CODE" || { echo "Error: Failed to set executable permission"; exit 1; }

# Create APT hook
echo 'DPkg::Post-Invoke { "fixchrome"; };' > "$APT_HOOK_PATH" && echo "Created APT hook at $APT_HOOK_PATH"

# Executable fixchrome immediately
sudo fixchrome && echo "Initial fixchrome execution completed." || { echo "Error: fixchrome execution failed"; exit 1; }

echo "Installation complete." && echo "The fixchrome script will run automatically after Chrome updates." && echo "You can also run manually with custom language: sudo fixchrome <locale_code>"
