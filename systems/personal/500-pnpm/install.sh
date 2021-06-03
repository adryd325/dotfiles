#!/usr/bin/env bash
source $HOME/.adryd/constants.sh
source $AR_DIR/lib/os.sh
AR_MODULE="pnpm"

if [ "$AR_OS" == "darwin_macos" ]; then
    log info "Installing pnpm"
    npm install -g pnpm --silent
fi