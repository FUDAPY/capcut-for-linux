# CapCut for Linux (Wine Compatibility Layer)

An automated setup script and execution wrapper to configure an isolated, optimized 64-bit Wine environment for running CapCut Desktop on Linux distributions (Fedora / KDE Plasma, Debian, Ubuntu).

---

## English

### Overview
This project provides an automated configuration environment that addresses common compatibility issues encountered when running the Windows version of CapCut on modern Linux systems, notably:
- Resolving the video preview black screen issue in desktop environments such as KDE Plasma.
- Providing both installer execution and portable folder import to bypass common installer freezes.
- Maintaining clean isolation through a dedicated Wine prefix (`~/.local/share/capcut-linux/prefix`).

### System Requirements
- **Fedora Linux** (tested on KDE Plasma) or **Debian/Ubuntu**-based distributions.
- Required packages (handled automatically by `install.sh`):
  - `wine` (64-bit)
  - `winetricks`
  - `cabextract`

### Installation
1. Clone or download this repository:
   ```bash
   git clone https://github.com/FUDAPY/capcut-for-linux.git
   cd capcut-for-linux
   ```
2. Make scripts executable and run the installer:
   ```bash
   chmod +x install.sh uninstall.sh scripts/launch-capcut.sh
   ./install.sh
   ```
3. During setup, select one of the following methods:
   - **Option 1**: Provide the path to a local official CapCut Windows installer (`.exe`).
   - **Option 2**: Provide the path to an already extracted or installed CapCut directory from Windows to import it directly.

### Resolving the Video Preview Issue (KDE Plasma)
The installer automatically injects Wine X11 Driver registry settings (`Decorated=N`, `Managed=N`). If the canvas appears black when opening a new project:
- **Aspect Ratio Refresh**: Toggle the project's aspect ratio once (e.g., from 16:9 to 9:16 and back) inside CapCut. This triggers an immediate redraw of the video viewport.
- **KDE Compositor**: Ensure desktop effects / window transparency are enabled in KDE Plasma system settings.

### Uninstallation
To remove the isolated Wine prefix, launcher, and desktop shortcuts:
```bash
./uninstall.sh
```

### Disclaimer
This repository contains only configuration scripts, wrappers, and documentation for Wine. It does not distribute, host, modify, or license any proprietary third-party software or binaries. All trademarks, software titles, and assets belong exclusively to their respective owners.

---

## Español

### Descripción general
Este proyecto proporciona un entorno de configuración automatizado para ejecutar la versión de escritorio de CapCut en distribuciones Linux (Fedora / KDE Plasma, Debian, Ubuntu) dentro de un Wine Prefix aislado de 64 bits (`~/.local/share/capcut-linux/prefix`).

Resuelve fallos comunes del entorno:
- Evita el cuadro negro en el panel de previsualización de video (especialmente en KDE Plasma).
- Ofrece soporte tanto para instalador `.exe` como para importación directa de una carpeta ya instalada o extraída, evitando congelamientos durante la instalación.
- Mantiene el sistema anfitrión limpio sin modificar prefijos globales de Wine.

### Requisitos del Sistema
- **Fedora Linux** (con KDE Plasma u otro entorno) o distribuciones basadas en **Debian/Ubuntu**.
- Dependencias (gestionadas automáticamente por `install.sh`):
  - `wine` (64-bit)
  - `winetricks`
  - `cabextract`

### Instalación
1. Clona o descarga este repositorio:
   ```bash
   git clone https://github.com/FUDAPY/capcut-for-linux.git
   cd capcut-for-linux
   ```
2. Asigna permisos de ejecución e inicia el instalador:
   ```bash
   chmod +x install.sh uninstall.sh scripts/launch-capcut.sh
   ./install.sh
   ```
3. Selecciona tu método de despliegue preferido:
   - **Opción 1**: Proporcionar la ruta local de un instalador oficial de Windows (`.exe`).
   - **Opción 2**: Proporcionar la ruta de una carpeta de CapCut ya instalada o extraída desde Windows.

### Solución al cuadro negro en la previsualización (KDE Plasma)
El instalador aplica automáticamente las claves de registro del controlador X11 de Wine (`Decorated=N`, `Managed=N`). Si al crear un proyecto el visor permanece en negro:
- **Refresco de Relación de Aspecto**: Cambia temporalmente la relación de aspecto del proyecto dentro de CapCut (por ejemplo, de 16:9 a 9:16 y luego de vuelta a 16:9). Esto fuerza al motor gráfico a repintar el visor de video.
- **Compositor de KDE**: Asegúrate de que los efectos de ventana y la transparencia de diálogos estén activos en la configuración de KDE Plasma.

### Desinstalación
Para eliminar de forma limpia el Wine Prefix, el script de lanzamiento y los accesos directos creados:
```bash
./uninstall.sh
```

### Descargo de responsabilidad
Este repositorio contiene exclusivamente scripts de compatibilidad, automatización y documentación para Wine. No distribuye, aloja, modifica ni comercializa software propietario ni binarios de terceros. Todas las marcas registradas y derechos sobre el software pertenecen a sus respectivos autores.
