#!/usr/bin/env bash
source $HOME/.adryd/constants.sh
source $AR_DIR/lib/os.sh
AR_MODULE="startup"

if [ "$AR_OS" == "linux_arch" ] || [ "$AR_OS" == "darwin_macos" ]; then
    if [ "$AR_OS" == "linux_arch" ] && [ "$USER" == "root" ] && [ "$HOSTNAME" == "archiso" ]; then
        $AR_DIR/systems/personal/arch-install/_install.sh
    else
        [ "$USER" != "root" ] \
            && $AR_DIR/systems/personal/install.sh
    fi
fi

if [ "$AR_OS" == "linux_debian" ]; then
    if [ "$USER" == "root" ]; then
        $AR_DIR/systems/server/vms/install.sh
    fi
fi