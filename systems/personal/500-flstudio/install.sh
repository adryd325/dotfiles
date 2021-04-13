#!/bin/bash
source $HOME/.adryd/constants.sh
source $AR_DIR/lib/os.sh
source $AR_DIR/lib/tmp.sh
AR_MODULE="flstudio"

downloadURL="https://support.image-line.com/redirect/flstudio20_win_installer"
workDir="$AR_TMP/flstudio"

if [ "$AR_OS" == "linux_archlinux" ] && pacman -Q wine &> /dev/null; then
    if [ "$DISPLAY" != "" ]; then
        log info "Downloading FL Studio"
        mkdir -p $workDir
        curl -fsSLo $workDir/flstudio.exe $downloadURL
        log info "Starting FL Studio installer"
        wine $workDir/flstudio.exe
    else
        log info "Postponing FL Studio install until in DE"
    fi
fi

