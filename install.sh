#!/usr/bin/env bash
# ==============================================================================
# CapCut for Linux - Automated Setup Script
# Target: Fedora (KDE Plasma) & Debian/Ubuntu distributions
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_ROOT="${HOME}/.local/share/capcut-linux"
WINE_PREFIX="${INSTALL_ROOT}/prefix"
SCRIPTS_DIR="${INSTALL_ROOT}/scripts"
LAUNCHER_SCRIPT="${SCRIPTS_DIR}/launch-capcut.sh"

export WINEPREFIX="${WINE_PREFIX}"
export WINEARCH="win64"
export WINEDEBUG="-all"

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}==========================================================${NC}"
echo -e "${BLUE}         CapCut for Linux - Environment Setup             ${NC}"
echo -e "${BLUE}==========================================================${NC}"

# Prevent running directly as root
if [[ "${EUID}" -eq 0 ]]; then
    echo -e "${RED}[-] Do not run this script as root or with sudo.${NC}"
    echo "    Wine prefixes must be owned by your standard user account."
    exit 1
fi

# 1. Dependency Detection and Installation
echo -e "\n${YELLOW}[Step 1/5] Checking system dependencies...${NC}"

MISSING_DEPS=()
for cmd in wine winetricks cabextract; do
    if ! command -v "${cmd}" &>/dev/null; then
        MISSING_DEPS+=("${cmd}")
    fi
done

if [[ ${#MISSING_DEPS[@]} -gt 0 ]]; then
    echo -e "${YELLOW}[!] Missing required packages: ${MISSING_DEPS[*]}${NC}"
    if command -v dnf &>/dev/null; then
        echo "[*] Detected Fedora / RPM-based system (dnf)."
        sudo dnf install -y wine winetricks cabextract
    elif command -v apt-get &>/dev/null; then
        echo "[*] Detected Debian / Ubuntu system (apt)."
        sudo apt-get update
        sudo apt-get install -y wine wine64 winetricks cabextract
    else
        echo -e "${RED}[-] Unsupported package manager. Please install: ${MISSING_DEPS[*]}${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}[+] Core system dependencies are already installed.${NC}"
fi

# 2. Wine Prefix Initialization
echo -e "\n${YELLOW}[Step 2/5] Initializing isolated 64-bit Wine prefix...${NC}"
mkdir -p "${WINE_PREFIX}" "${SCRIPTS_DIR}"
wineboot -u

# 3. Winetricks & Compatibility Libraries
echo -e "\n${YELLOW}[Step 3/5] Installing compatibility components via Winetricks...${NC}"
echo "    Installing: vcrun2019, corefonts, Windows 11 target profile..."
winetricks -q vcrun2019 corefonts win11

# 4. Registry Configuration (Fix black preview pane in KDE / X11)
echo -e "\n${YELLOW}[Step 4/5] Applying Wine display driver registry optimizations...${NC}"
wine reg add "HKCU\\Software\\Wine\\X11 Driver" /v Decorated /t REG_SZ /d "N" /f
wine reg add "HKCU\\Software\\Wine\\X11 Driver" /v Managed /t REG_SZ /d "N" /f

# 5. Application Payload Deployment
echo -e "\n${YELLOW}[Step 5/5] Deploying CapCut binary...${NC}"
echo "Choose deployment method:"
echo "  1) Run an existing CapCut installer (.exe) in this Wine prefix"
echo "  2) Import an already installed / extracted CapCut folder"
read -r -p "Enter choice [1 or 2]: " DEPLOY_MODE

case "${DEPLOY_MODE}" in
    1)
        read -r -e -p "Enter path to your CapCut installer (.exe): " INSTALLER_PATH
        INSTALLER_PATH="${INSTALLER_PATH/#\~/$HOME}"
        if [[ ! -f "${INSTALLER_PATH}" ]]; then
            echo -e "${RED}[-] File not found: ${INSTALLER_PATH}${NC}"
            exit 1
        fi
        echo "[*] Running installer within Wine prefix. Complete the setup wizard..."
        wine "${INSTALLER_PATH}"
        ;;
    2)
        read -r -e -p "Enter path to existing CapCut directory: " SOURCE_FOLDER
        SOURCE_FOLDER="${SOURCE_FOLDER/#\~/$HOME}"
        if [[ ! -d "${SOURCE_FOLDER}" ]]; then
            echo -e "${RED}[-] Directory not found: ${SOURCE_FOLDER}${NC}"
            exit 1
        fi
        DEST_DIR="${WINE_PREFIX}/drive_c/Program Files/CapCut"
        mkdir -p "${DEST_DIR}"
        echo "[*] Copying files to ${DEST_DIR}..."
        cp -r "${SOURCE_FOLDER}/." "${DEST_DIR}/"
        ;;
    *)
        echo -e "${RED}[-] Invalid option selected. Exiting.${NC}"
        exit 1
        ;;
esac

# Install wrapper script
cp "${SCRIPT_DIR}/scripts/launch-capcut.sh" "${LAUNCHER_SCRIPT}"
chmod +x "${LAUNCHER_SCRIPT}"

# Create Desktop Entry
APPLICATIONS_DIR="${HOME}/.local/share/applications"
DESKTOP_DIR="$(xdg-user-dir DESKTOP 2>/dev/null || echo "${HOME}/Desktop")"
mkdir -p "${APPLICATIONS_DIR}"

DESKTOP_FILE="${APPLICATIONS_DIR}/capcut.desktop"
cat > "${DESKTOP_FILE}" <<EOF
[Desktop Entry]
Name=CapCut
Comment=CapCut Video Editor on Linux
Exec=${LAUNCHER_SCRIPT} %F
Icon=video-x-generic
Terminal=false
Type=Application
Categories=AudioVideo;Video;AudioVideoEditing;
StartupWMClass=capcut.exe
EOF

chmod +x "${DESKTOP_FILE}"

if [[ -d "${DESKTOP_DIR}" ]]; then
    cp "${DESKTOP_FILE}" "${DESKTOP_DIR}/capcut.desktop"
    chmod +x "${DESKTOP_DIR}/capcut.desktop"
fi

ALT_DESKTOP="${HOME}/Escritorio"
if [[ -d "${ALT_DESKTOP}" && "${ALT_DESKTOP}" != "${DESKTOP_DIR}" ]]; then
    cp "${DESKTOP_FILE}" "${ALT_DESKTOP}/capcut.desktop"
    chmod +x "${ALT_DESKTOP}/capcut.desktop"
fi

if command -v update-desktop-database &>/dev/null; then
    update-desktop-database "${APPLICATIONS_DIR}" 2>/dev/null || true
fi

echo -e "\n${GREEN}==========================================================${NC}"
echo -e "${GREEN}[+] CapCut setup completed successfully!                 ${NC}"
echo -e "${GREEN}==========================================================${NC}"
echo "Launcher created at: ${LAUNCHER_SCRIPT}"
echo "Desktop entry:       ${DESKTOP_FILE}"
echo ""
echo -e "${YELLOW}[IMPORTANT USAGE NOTE - KDE PLASMA / LINUX PREVIEW]:${NC}"
echo "If the video preview window displays a black screen when creating a project:"
echo "1. Change the project's Aspect Ratio once inside CapCut (e.g., from 16:9 to 9:16 and back)."
echo "   This forces the graphics subsystem to trigger an immediate viewport redraw."
echo "2. Alternatively, verify that window effects / compositor transparency are active in KDE."
echo "=========================================================="
