#!/usr/bin/env bash
source $HOME/.adryd/constants.sh
source $AR_DIR/lib/os.sh
AR_MODULE="fontconfig"

if [ "$AR_OS" == "linux_arch" ]; then
    if [ ! -e "$HOME/.config/fontconfig/fonts.conf" ]; then
        log info "Installing fontconfig"
        mkdir -p "$HOME/.config/fontconfig"
        cp "$AR_DIR/systems/personal/$AR_MODULE/fonts.conf" "$HOME/.config/fontconfig/fonts.conf"
    fi
fi
