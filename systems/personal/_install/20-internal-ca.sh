#!/usr/bin/env bash
source $HOME/.adryd/constants.sh
source $AR_DIR/lib/os.sh
AR_MODULE="ca-certificates"

if [ "$AR_OS" == "linux_arch" ] && [ "$USER" == "adryd" ]; then
    log info "Trusting internal CA"
    sudo trust anchor --store "$AR_DIR/systems/common/$AR_MODULE/adryd-root-ca.pem"
fi