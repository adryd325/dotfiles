#!/usr/bin/env bash
source $HOME/.adryd/constants.sh
source $AR_DIR/lib/os.sh
AR_MODULE="xdg-user-dirs"

if [ "$AR_OS" == "linux_arch" ]; then
    if [ ! -e "$HOME/.config/user-dirs.dirs" ]; then
        log info "Installing xdg-user-dirs config"
        cp "$AR_DIR/systems/personal/$AR_MODULE/user-dirs.dirs" "$HOME/.config/user-dirs.dirs"
    fi
fi
