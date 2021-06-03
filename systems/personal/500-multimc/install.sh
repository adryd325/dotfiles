#!/usr/bin/env bash
source $HOME/.adryd/constants.sh
AR_MODULE="multimc"

# TODO: make platform agnostic
# brew check if multimc is installed
# set multimc dir to a variable

if [ "$AR_OS" == "linux_arch" ] && pacman -Q multimc-git &> /dev/null; then
    # Make multimc dir if it doesn't already exist
    [ -e "$HOME/.local/share/multimc" ] \
        || mkdir -p "$HOME/.local/share/multimc"

    # If the multimc config doesn't already exist
    if [ ! -e "$HOME/.local/share/multimc/multimc.cfg" ]; then
        # Copy the default config in place
        cp "$AR_DIR/systems/personal/500-multimc/multimc.cfg" "$HOME/.local/share/multimc/multimc.cfg" \
            && log info "Installing multimc config"

        # If we're on popsicle, add additional options for nvidia optimus and more ram availibility
        [ "$HOSTNAME" == "popsicle" ] \
            && cat "$AR_DIR/systems/personal/500-multimc/multimc-popsicle.cfg" >> "$HOME/.local/share/multimc/multimc.cfg" \
            && log info "Installing popsicle-specific config"
    fi
fi
