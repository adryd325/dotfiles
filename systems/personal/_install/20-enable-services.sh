#!/usr/bin/env bash
[[ -z "$AR_DIR" ]] && echo "Please set AR_DIR in your environment" && exit 0; source $AR_DIR/constants.sh
ar_os
AR_MODULE="enable-services"

# Enable services that otherwise don't need their own install script
if [ "$AR_OS" == "linux_arch" ]; then
    if pacman -Q gdm &> /dev/null; then
        log info "Enabling gdm"
        sudo systemctl enable gdm --now > /dev/null
    fi
    if pacman -Q cups &> /dev/null; then
        log info "Enabling cups"
        sudo systemctl enable cups --now > /dev/null
    fi
    if pacman -Q qemu-guest-agent &> /dev/null; then
        log info "Enabling qemu-guest-agent"
        sudo systemctl enable qemu-guest-agent --now  > /dev/null
    fi
    sudo systemctl enable systemd-resolved --now  > /dev/null
fi