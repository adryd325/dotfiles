#!/bin/bash
source $HOME/.adryd/constants.sh
AR_MODULE="multimc"

if [ "$AR_OS" == "linux_archlinux" ] && pacman -Q multimc-git &> /dev/null; then
    [ -e "$HOME/.local/share/multimc" ] || mkdir -p "$HOME/.local/share/multimc"
    if [ ! -e "$HOME/.local/share/multimc/multimc.cfg" ]; then
        cp "$AR_DIR/systems/personal/500-multimc/multimc.cfg" "$HOME/.local/share/multimc/multimc.cfg" \
            && log info "Installing multimc config"
        [ "$HOSTNAME" == "popsicle" ] \
            && cat "$AR_DIR/systems/personal/500-multimc/multimc-popsicle.cfg" >> "$HOME/.local/share/multimc/multimc.cfg" \
            && log info "Installing popsicle-specific config (optimus)"
    fi
fi
