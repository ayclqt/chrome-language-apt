# Chrome Locale Fixer

Automatically set Chrome's locale on Linux by injecting `export LANGUAGE` into the Chrome launcher script.

## Problem

Sometimes you want to use Google Chrome in a different language than your system locale. This tool allows you to set a specific language for Chrome regardless of your system settings by modifying Chrome's launch script.

## Features

- Automatically fixes Chrome locale after updates via APT hook
- Configurable default language during installation
- Can be run manually with custom language codes
- Backs up original Chrome script before modification

## Files

- `fixchrome` - Script that modifies Chrome's launcher to set locale
- `install.sh` - Installer that deploys fixchrome and sets up APT hook

> [!NOTE]
> Installing the next update for Google Chrome resets `/opt/google/chrome/google-chrome`, so this file editing procedure needs to be done after each update.

## Installation

### Quick Install (Recommended)

Using curl to download and run the installer directly:

**Default Language (vi_VN)**
```bash
curl -fsSL https://raw.githubusercontent.com/ayclqt/chrome-language-apt/main/install.sh | sudo bash
```

**Custom Default Language**
```bash
curl -fsSL https://raw.githubusercontent.com/ayclqt/chrome-language-apt/main/install.sh | sudo bash -s en_US
curl -fsSL https://raw.githubusercontent.com/ayclqt/chrome-language-apt/main/install.sh | sudo bash -s ja_JP
curl -fsSL https://raw.githubusercontent.com/ayclqt/chrome-language-apt/main/install.sh | sudo bash -s zh_CN
```

### Install from Source

If you prefer to clone the repository and run locally:

```bash
git clone https://github.com/ayclqt/chrome-language-apt.git
cd chrome-language-apt
chmod +x install.sh
sudo ./install.sh
```

Or with custom language:
```bash
sudo ./install.sh en_US
```

### What the installer does

This will:
1. Copy `fixchrome` to `/usr/local/bin/fixchrome` (downloads from GitHub if not found locally)
2. Set the specified language as default in fixchrome
3. Make fixchrome executable
4. Create APT hook at `/etc/apt/apt.conf.d/99chrome-locale`

## Usage

### Automatic (Recommended)

After installation, fixchrome runs automatically whenever Chrome is updated via APT.

### Manual Execution

Run with default language:
```bash
sudo fixchrome
```

Run with custom language:
```bash
sudo fixchrome en_US
sudo fixchrome ja_JP
```

## How It Works

The `fixchrome` script:
1. Checks if `export LANGUAGE=` already exists in Chrome's launcher
2. If not found, backs up the original script
3. Inserts `export LANGUAGE="<locale>"` after the first line (shebang)
4. Chrome will now use the specified locale

## Supported Locales

Any valid locale code, such as:
- `vi_VN` - Vietnamese
- `en_US` - English (US)
- `ja_JP` - Japanese
- `zh_CN` - Chinese (Simplified)
- `ko_KR` - Korean
- `th_TH` - Thai

## Uninstallation

```bash
sudo rm /usr/local/bin/fixchrome
sudo rm /etc/apt/apt.conf.d/99chrome-locale
```

To restore original Chrome script:
```bash
sudo cp /opt/google/chrome/google-chrome.old /opt/google/chrome/google-chrome
```

## Requirements

- Google Chrome installed at `/opt/google/chrome/google-chrome`
- Root/sudo access
- APT package manager (Debian/Ubuntu-based systems)

## License

MIT License

Copyright (c) 2025 ayclqt

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
