#!/usr/bin/env bash
# ==============================================================================
# CapCut Linux Wrapper Launcher
# ==============================================================================
set -euo pipefail

export WINEPREFIX="${HOME}/.local/share/capcut-linux/prefix"
export WINEARCH="win64"
export WINEDEBUG="-all"
export DXVK_ASYNC=1
export DXVK_STATE_CACHE=1
export WINE_VK_VULKAN_RENDER_PASS=1
export STAGING_SHARED_MEMORY=1

# Candidate paths for the executable inside the prefix
CANDIDATES=(
    "${WINEPREFIX}/drive_c/Program Files/CapCut/CapCut.exe"
    "${WINEPREFIX}/drive_c/Program Files (x86)/CapCut/CapCut.exe"
    "${WINEPREFIX}/drive_c/users/${USER}/AppData/Local/CapCut/CapCut.exe"
)

TARGET_EXE=""
for path in "${CANDIDATES[@]}"; do
    if [[ -f "${path}" ]]; then
        TARGET_EXE="${path}"
        break
    fi
done

# Fallback: search within AppData and Program Files
if [[ -z "${TARGET_EXE}" ]]; then
    FOUND=$(find "${WINEPREFIX}/drive_c" -maxdepth 5 -type f -iname "CapCut.exe" 2>/dev/null | head -n 1 || true)
    if [[ -n "${FOUND}" && -f "${FOUND}" ]]; then
        TARGET_EXE="${FOUND}"
    fi
fi

if [[ -z "${TARGET_EXE}" ]]; then
    echo "[-] Error: CapCut.exe could not be located in ${WINEPREFIX}" >&2
    echo "[!] Run install.sh to install or configure CapCut first." >&2
    exit 1
fi

exec wine "${TARGET_EXE}" "$@"
