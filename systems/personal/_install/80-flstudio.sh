#!/usr/bin/env bash
# shellcheck source=../../../constants.sh
[[ -z "$AR_DIR" ]] && echo "Please set AR_DIR in your environment" && exit 0; source "$AR_DIR"/constants.sh
ar_os
ar_tmp
AR_MODULE="flstudio"

downloadURL="https://support.image-line.com/redirect/flstudio20_win_installer"
workDir="$AR_TMP/$AR_MODULE"

if [ "$AR_OS" == "linux_arch" ] && pacman -Q wine &> /dev/null; then
    # Check to make sure we have a display
    if [ "$DISPLAY" != "" ]; then
        log info "Downloading FL Studio"
        mkdir -p "$workDir"
        # if statement to make sure the rest doesn't happen if the download fails
        if curl -fsSLo "$workDir"/flstudio.exe $downloadURL; then
            log info "Starting FL Studio installer"
            wine "$workDir"/flstudio.exe &> /dev/null
        fi
    else
        # We can't install from tty
        log info "Postponing FL Studio install until in DE"
    fi
fi

