#!/usr/bin/env bash
source $HOME/.adryd/constants.sh
source $AR_DIR/lib/os.sh
AR_MODULE="optimus"

if [ "$AR_OS" == "linux_arch" ]; then
    # Make sure we have gdm, or something that provides gdm
    if pacman -Q gdm &> /dev/null; then
        log info "Disable Wayland"
        # Backup existing config
        [ ! -e /etc/gdm/custom.conf.arbak ] \
            && sudo cp /etc/gdm/custom.conf /etc/gdm/custom.conf.arbak
        sudo sed -i "s/#WaylandEnable=false/WaylandEnable=false/" /etc/gdm/custom.conf

        # If we have optimus manager
        # The logs are rather self-explainatory so no need for more comment
        if pacman -Q optimus-manager &> /dev/null; then
            log info "Copy optimus-manager config"
            mkdir -p /etc/optimus-manager
            sudo cp -f "$AR_DIR/systems/personal/050-optimus-manager/optimus-manager.conf" /etc/optimus-manager/optimus-manager.conf
            log info "Enable optimus-manager"
            sudo systemctl enable optimus-manager
        fi
        if pacman -Q switcheroo-control &> /dev/null; then
            log info "Enable switcheroo-control"
            sudo systemctl enable switcheroo-control
        fi
    fi
fi