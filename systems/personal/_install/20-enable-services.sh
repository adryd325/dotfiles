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
        sudo systemctl enable gdm > /dev/null
    fi
    if pacman -Q cups &> /dev/null; then
        log info "Enabling cups"
        sudo systemctl enable cups > /dev/null
    fi
    if pacman -Q qemu-guest-agent &> /dev/null; then
        log info "Enabling qemu-guest-agent"
        sudo systemctl enable qemu-guest-agent > /dev/null
    fi
    if pacman -Q touchegg &> /dev/null; then
        log info "Enabling touchegg"
        sudo systemctl enable touchegg > /dev/null
    fi
    if pacman -Q thermald &> /dev/null; then
        log info "Enabling thermald"
        sudo systemctl enable thermald > /dev/null
    fi
    if pacman -Q auto-cpufreq &> /dev/null; then
        log info "Enabling auto-cpufreq"
        sudo systemctl enable auto-cpufreq > /dev/null
    fi
    if pacman -Q libvirtd &> /dev/null; then
        log info "Enabling libvirtd"
        sudo systemctl enable libvirtd > /dev/null
    fi
    if pacman -Q pipewire &> /dev/null; then
        log info "Enabling pipewire"
        sudo systemctl --user enable pipewire > /dev/null
        sudo systemctl --user enable pipewire-pulse > /dev/null
    fi
    sudo systemctl enable systemd-resolved > /dev/null
fi