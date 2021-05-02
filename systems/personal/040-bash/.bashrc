#!/bin/bash

# load .adryd constants so we have $AR_DIR
# set splash to 1 so it doesnt fire when calling constants
AR_SPLASH=1 source $HOME/.adryd/constants.sh
export PATH="$HOME/.adryd/bin:$HOME/.local/bin:$PATH"
export EDITOR="nvim"