#!/usr/bin/env bash
# ==============================================================================
# CapCut Linux Uninstaller
# ==============================================================================
set -euo pipefail

DATA_DIR="${HOME}/.local/share/capcut-linux"
DESKTOP_APP="${HOME}/.local/share/applications/capcut.desktop"

DESKTOP_DIR="$(xdg-user-dir DESKTOP 2>/dev/null || echo "${HOME}/Desktop")"
DESKTOP_SHORTCUT="${DESKTOP_DIR}/capcut.desktop"
ALT_DESKTOP_SHORTCUT="${HOME}/Escritorio/capcut.desktop"

echo "=========================================================="
echo "          CapCut for Linux - Uninstaller                  "
echo "=========================================================="
echo "This will remove the isolated Wine prefix, wrapper scripts,"
echo "and desktop shortcuts created for CapCut."
echo ""
read -r -p "Are you sure you want to proceed? [y/N]: " CONFIRM

if [[ ! "${CONFIRM}" =~ ^[Yy]$ ]]; then
    echo "[*] Uninstallation cancelled."
    exit 0
fi

echo "[*] Removing Wine prefix and wrapper files..."
if [[ -d "${DATA_DIR}" ]]; then
    rm -rf "${DATA_DIR}"
    echo "    Removed: ${DATA_DIR}"
fi

echo "[*] Removing application desktop launcher..."
if [[ -f "${DESKTOP_APP}" ]]; then
    rm -f "${DESKTOP_APP}"
    echo "    Removed: ${DESKTOP_APP}"
fi

echo "[*] Removing desktop shortcut..."
if [[ -f "${DESKTOP_SHORTCUT}" ]]; then
    rm -f "${DESKTOP_SHORTCUT}"
    echo "    Removed: ${DESKTOP_SHORTCUT}"
fi
if [[ -f "${ALT_DESKTOP_SHORTCUT}" ]]; then
    rm -f "${ALT_DESKTOP_SHORTCUT}"
    echo "    Removed: ${ALT_DESKTOP_SHORTCUT}"
fi

if command -v update-desktop-database &>/dev/null; then
    update-desktop-database "${HOME}/.local/share/applications/" 2>/dev/null || true
fi

echo "=========================================================="
echo "[+] Uninstallation completed successfully."
echo "=========================================================="
