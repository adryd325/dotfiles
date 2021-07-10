#!/usr/bin/env bash
[[ -z "$AR_DIR" ]] && echo "Please set AR_DIR in your environment" && exit 0; source $AR_DIR/constants.sh
ar_os
AR_MODULE="thinkpad_acpi"

if [ "$AR_OS" == "linux_arch" ]; then
    if [ ! -e "/etc/modprobe.d/thinkpad_acpi.conf" ]; then
        log info "Installing thinkpad_acpi config"
        sudo tee /etc/modprobe.d/thinkpad_acpi.conf > /dev/null << EOF
options thinkpad_acpi fan_control = 1
EOF
    fi
fi