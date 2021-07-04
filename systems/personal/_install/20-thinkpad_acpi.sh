#!/usr/bin/env bash
source $HOME/.adryd/constants.sh
source $AR_DIR/lib/os.sh
AR_MODULE="thinkpad_acpi"

if [ "$AR_OS" == "linux_arch" ]; then
    if [ ! -e "/etc/modprobe.d/thinkpad_acpi.conf" ]; then
        log info "Installing thinkpad_acpi config"
        sudo tee /etc/modprobe.d/thinkpad_acpi.conf > /dev/null << EOF
options thinkpad_acpi fan_control = 1
EOF
    fi
fi