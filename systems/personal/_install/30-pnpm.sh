#!/usr/bin/env bash
[[ -z "$AR_DIR" ]] && echo "Please set AR_DIR in your environment" && exit 0; source $AR_DIR/constants.sh
ar_os
AR_MODULE="pnpm"

if [ "$AR_OS" == "darwin_macos" ]; then
    log info "Installing pnpm"
    npm install -g pnpm --silent
fi