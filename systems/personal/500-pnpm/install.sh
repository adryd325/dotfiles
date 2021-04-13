#!/bin/bash
source $HOME/.adryd/constants.sh
source $AR_DIR/lib/os.sh
AR_MODULE="pnpm"

if [ "$AR_OS" == "linux_archlinux" ]; then
    log info "Installing pnpm"
    sudo npm install -g pnpm
elif [ "$AR_OS" == "darwin_macos" ]; then
    log info "Installing pnpm"
    npm install -g pnpm
fi