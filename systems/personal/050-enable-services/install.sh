#!/bin/bash
source $HOME/.adryd/constants.sh
source $AR_DIR/lib/os.sh
AR_MODULE="enable-services"

if [ "$AR_OS" == "linux_archlinux" ]; then
    if pacman -Q gdm &> /dev/null; then
        log info "Enabling gdm"
        sudo systemctl enable gdm
    fi
    if pacman -Q cups &> /dev/null; then
        log info "Enabling cups"
        sudo systemctl enable cups
    fi
    if pacman -Q qemu-guest-agent &> /dev/null; then
        log info "Enabling qemu-guest-agent"
        sudo systemctl enable qemu-guest-agent
    fi
fi