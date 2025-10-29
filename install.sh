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
REPO_URL="https://raw.githubusercontent.com/ayclqt/chrome-language-apt/main"

echo "Installing fixchrome with default language: $LANGUAGE_CODE"

# Check if fixchrome exists in current directory
if [ ! -f "$FIXCHROME_SOURCE" ]; then
    echo "fixchrome not found locally, downloading from GitHub..."
    curl -fsSL "$REPO_URL/fixchrome" -o "$FIXCHROME_DEST"

    if [ ! -f "$FIXCHROME_DEST" ]; then
        echo "Error: Failed to download fixchrome"
        exit 1
    fi
else
    echo "Using local fixchrome"
    cp "$FIXCHROME_SOURCE" "$FIXCHROME_DEST"
fi

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
