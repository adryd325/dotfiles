#!/usr/bin/env bash

# load .adryd constants so we have $AR_DIR
# set splash to 1 so it doesnt fire when calling constants
AR_SPLASH=1 source $HOME/.adryd/constants.sh
export PATH="$HOME/.adryd/systems/personal/bin:$HOME/.local/bin:$PATH"
export EDITOR="nvim"

source "$AR_DIR/systems/personal/bash/aliases.sh"