#!/usr/bin/env bash
# shellcheck source=../../../constants.sh
[[ -z "${AR_DIR}" ]] && echo "Please set AR_DIR in your environment" && exit 0; source "${AR_DIR}"/constants.sh
ar_os
AR_MODULE="enable-services"

# Enable services that otherwise don't need their own install script
if [[ "${AR_OS}" = "linux_arch" ]]; then
    # todo: make for loop? doesnt work for some packages
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
    if pacman -Q touchegg &> /dev/null; then
        log info "Enabling touchegg"
        sudo systemctl enable touchegg --now  > /dev/null
    fi
    if pacman -Q tlp &> /dev/null; then
        log info "Enabling tlp"
        sudo systemctl enable tlp --now  > /dev/null
    fi
    if pacman -Q pipewire &> /dev/null; then
        log info "Enabling pipewire"
        sudo systemctl --user enable pipewire --now  > /dev/null
        sudo systemctl --user enable pipewire-pulse --now  > /dev/null
    fi
    sudo systemctl enable systemd-resolved --now  > /dev/null
fi