#!/bin/bash
source $HOME/.adryd/constants.sh
source $AR_DIR/lib/os.sh
AR_MODULE="sysrq"

if [ "$AR_OS" == "linux_arch" ]; then
    [ ! -e "/etc/sysctl.d/10-sysrq.conf" ] \
        && log info "Installing sysrq config" \
        && sudo cp "$AR_DIR/systems/personal/050-sysrq/10-sysrq.conf" "/etc/sysctl.d/10-sysrq.conf"
fi