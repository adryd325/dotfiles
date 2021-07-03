#!/usr/bin/env bash
source $HOME/.adryd/constants.sh
source $AR_DIR/lib/os.sh
AR_MODULE="sysctl"

if [ "$AR_OS" == "linux_arch" ]; then
    if [ ! -e "/etc/sysctl.d/99-sysrq.conf" ]; then
        log info "Installing sysrq config"
        sudo cp "$AR_DIR/systems/personal/$AR_MODULE/99-sysrq.conf" "/etc/sysctl.d/99-sysrq.conf"
    fi
fi