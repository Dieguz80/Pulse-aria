#!/usr/bin/env bash
# Pulse-Aria macOS installer script
# Pattern: 2-step (this is the "run" part; user already downloaded this file)
# What this script does:
#   1. Detects architecture (Apple Silicon vs Intel)
#   2. Downloads the appropriate Pulse-Aria .dmg from GitHub Releases
#   3. Verifies the file was actually downloaded
#   4. Mounts the .dmg, drags Pulse-Aria.app to /Applications, unmounts
# Manual alternative: https://github.com/Dieguz80/Pulse-aria/releases/latest

set -euo pipefail

readonly RELEASE_BASE='https://github.com/Dieguz80/Pulse-aria/releases/latest/download'
readonly TMP_DIR="$(mktemp -d)"
readonly APP_NAME='Pulse-Aria'

cleanup() {
  if [ -d "$TMP_DIR" ]; then
    rm -rf "$TMP_DIR" 2>/dev/null || true
  fi
  # Unmount any leftover mount points
  for mp in /Volumes/Pulse-Aria*; do
    [ -d "$mp" ] && hdiutil detach "$mp" -quiet 2>/dev/null || true
  done
}
trap cleanup EXIT

echo ""
echo "  Pulse-Aria — macOS Installer"
echo "  ============================"
echo ""

# Pre-flight: macOS only
if [ "$(uname -s)" != "Darwin" ]; then
  echo "[X] This script is for macOS only." >&2
  echo "    For Windows, see scripts/install.ps1" >&2
  exit 1
fi

# Step 1: Detect architecture
echo "[1/4] Detecting architecture..."
arch="$(uname -m)"
case "$arch" in
  arm64)
    asset='pulse-aria-macos-arm64.dmg'
    arch_label='Apple Silicon (M1/M2/M3/M4)'
    ;;
  x86_64)
    asset='pulse-aria-macos-intel.dmg'
    arch_label='Intel'
    ;;
  *)
    echo "[X] Unsupported architecture: $arch" >&2
    exit 1
    ;;
esac
echo "      Architecture: $arch_label"

url="$RELEASE_BASE/$asset"
dmg_path="$TMP_DIR/$asset"

# Step 2: Download
echo ""
echo "[2/4] Downloading latest installer..."
echo "      From: $url"
echo "      To:   $dmg_path"
echo ""

if ! curl -fL --progress-bar -o "$dmg_path" "$url"; then
  echo ""
  echo "[X] Download failed." >&2
  echo "" >&2
  echo "    Manual download:" >&2
  echo "    https://github.com/Dieguz80/Pulse-aria/releases/latest" >&2
  exit 1
fi

# Step 3: Verify
echo ""
echo "[3/4] Verifying download..."

if [ ! -f "$dmg_path" ]; then
  echo "[X] File not found after download." >&2
  exit 1
fi

size_bytes="$(stat -f%z "$dmg_path" 2>/dev/null || stat -c%s "$dmg_path" 2>/dev/null || echo 0)"
size_mb=$(( size_bytes / 1024 / 1024 ))
echo "      Size: ${size_mb} MB"

if [ "$size_mb" -lt 1 ]; then
  echo "[X] Downloaded file too small (${size_mb} MB). Likely a redirect error." >&2
  exit 1
fi

echo ""
echo "      SHA256:"
echo "      $(shasum -a 256 "$dmg_path" | awk '{print $1}')"
echo ""
echo "      Compare with the SHA256 in the release notes:"
echo "      https://github.com/Dieguz80/Pulse-aria/releases/latest"
echo ""

# Step 4: Mount + install
echo "[4/4] Installing..."

mount_output="$(hdiutil attach "$dmg_path" -nobrowse -quiet)"
mount_point="$(echo "$mount_output" | grep -E '^/Volumes/' | head -n1 | awk '{print $NF}')"

if [ -z "$mount_point" ] || [ ! -d "$mount_point" ]; then
  echo "[X] Failed to mount disk image." >&2
  exit 1
fi
echo "      Mounted: $mount_point"

# Find the .app inside (filename may vary, glob)
app_src="$(find "$mount_point" -maxdepth 2 -name '*.app' -type d | head -n1)"

if [ -z "$app_src" ]; then
  echo "[X] No .app bundle found in the .dmg." >&2
  hdiutil detach "$mount_point" -quiet 2>/dev/null || true
  exit 1
fi

dest="/Applications/$(basename "$app_src")"

# If old version exists, remove first
if [ -d "$dest" ]; then
  echo "      Removing previous version: $dest"
  rm -rf "$dest"
fi

echo "      Copying $(basename "$app_src") to /Applications..."
cp -R "$app_src" /Applications/

hdiutil detach "$mount_point" -quiet 2>/dev/null || true

# Remove the quarantine attribute so macOS doesn't refuse to open it later
# (Gatekeeper warning will still appear once, but user only has to confirm in Settings)
xattr -dr com.apple.quarantine "$dest" 2>/dev/null || true

echo ""
echo "[OK] Installation complete."
echo ""
echo "     Launch Pulse-Aria from /Applications and follow the onboarding."
echo ""
echo "     Note: On first launch, macOS Gatekeeper may show:"
echo "       \"Pulse-Aria cannot be opened because the developer cannot be verified.\""
echo "     This is because the app is not yet signed with an Apple Developer ID (coming in v0.6)."
echo ""
echo "     To open: System Settings → Privacy & Security → scroll to"
echo "     \"Pulse-Aria was blocked\" → click \"Open Anyway\" → enter password."
echo ""
