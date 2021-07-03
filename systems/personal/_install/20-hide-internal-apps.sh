#!/usr/bin/env bash
source $HOME/.adryd/constants.sh
source $AR_DIR/lib/os.sh
AR_MODULE="hide-internal-apps"

if [ "$AR_OS" == "linux_arch" ]; then
    source "$AR_DIR/systems/personal/$AR_MODULE/application-list.sh"
    log info "Hiding internal apps"
    for appDir in "${appDirs[@]}"; do
        for app in "${apps[@]}"; do
            if [ -e "$appDir/$app" ] && ! grep -l "NoDisplay=true" "$appDir/$app" > /dev/null; then
                log silly "Hiding $app from apps menu"
                echo "NoDisplay=true" | sudo tee -a "$appDir/$app" > /dev/null
            fi
        done
    done
fi