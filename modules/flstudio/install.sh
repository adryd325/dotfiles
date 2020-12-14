#!/bin/bash
source $AR_DOTFILES_DIR/lib/logger.sh
# needs curl, wine, regkey

arFlstudioDownloadUrl="https://support.image-line.com/redirect/flstudio20_win_installer"
arFlstudioWorkDir="/tmp/flstudio/"

log 4 flstudio "This installer requires user interaction."

# Make temp folder
log 0 flstudio "Making work folder."
mkdir -p $arFlstudioWorkDir

log 3 flstudio "Downloading installer exe."
curl -fsSL $arFlstudioDownloadUrl -o $arFlstudioWorkDir/flstudio.exe

log 3 flstudio "Starting installer."
bell
wine $arFlstudioWorkDir/flstudio.exe &> /dev/null

# TODO: auto activation with regkey or username/password
