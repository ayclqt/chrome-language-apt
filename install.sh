#!/bin/bash

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root or with sudo"
    exit 1
fi

LANGUAGE_CODE="${1:-vi_VN}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FIXCHROME_SOURCE="$SCRIPT_DIR/fixchrome"
FIXCHROME_DEST="/usr/local/bin/fixchrome"
APT_HOOK_PATH="/etc/apt/apt.conf.d/99chrome-locale"

# Check if fixchrome exists in current directory
if [ ! -f "$FIXCHROME_SOURCE" ]; then
    echo "Error: fixchrome script not found in $SCRIPT_DIR"
    exit 1
fi

echo "Installing fixchrome with default language: $LANGUAGE_CODE"

# Copy fixchrome to destination
cp "$FIXCHROME_SOURCE" "$FIXCHROME_DEST"

# Replace default language code
sed -i "s/LANGUAGE_CODE=\"\${1:-[^}]*}\"/LANGUAGE_CODE=\"\${1:-$LANGUAGE_CODE}\"/" "$FIXCHROME_DEST"

# Set executable permission
chmod +x "$FIXCHROME_DEST"
echo "Installed $FIXCHROME_DEST"

# Create APT hook
cat > "$APT_HOOK_PATH" << 'EOF'
DPkg::Post-Invoke {
    fixchrome
};
EOF

echo "Created $APT_HOOK_PATH"
echo ""
echo "Installation complete!"
echo "Default language: $LANGUAGE_CODE"
echo "The fixchrome script will run automatically after Chrome updates."
echo "You can also run manually with custom language: sudo fixchrome en_US"
