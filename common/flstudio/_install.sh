#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../../lib/log.sh
source ../../lib/os.sh
AR_MODULE="flstudio"

ensureInstalled wine
downloadURL="https://support.image-line.com/redirect/flstudio20_win_installer"

# Check to make sure we have a display
if [[ "${DISPLAY}" != "" ]]; then
    log info "Checking version"
    currentVer="$(curl -fsS https://support.image-line.com/redirect/flstudio20_win_installer -I | grep -e "^location: " | cut -d " " -f2)"
    if [[ -e "./lastver.txt" ]] && [[ "$(cat ./lastver.txt)" = "${currentVer}" ]]; then
        log info "No installation required, you are up to date."
        exit 0
    fi
    tee ./lastver.txt <<< "${currentVer}" > /dev/null
    log info "Downloading FL Studio"
    rm ./flstudio.exe 2> /dev/null
    # if statement to make sure the rest doesn't happen if the download fails
    if curl -fsSLo ./flstudio.exe "${downloadURL}"; then
        log info "Starting FL Studio installer"
        wine ./flstudio.exe &> /dev/null
    fi
else
    # We can't install from tty
    log info "Postponing FL Studio install until in DE"
fi

