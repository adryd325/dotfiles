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
        # The logs are rather self-explainatory so no need for more comment
        if [ "$HOSTNAME" == "popsicle" ]; then 
            log info "Setting power management kernel option"
            echo 'options nvidia "NVreg_DynamicPowerManagement=0x02"' | sudo tee /etc/modprobe.d/nvidia.conf > /dev/null
            log info "Setting udev rules"
            sudo tee /etc/udev/rules.d/80-nvidia-pm.rules > /dev/null <<EOF
# Enable runtime PM for NVIDIA VGA/3D controller devices on driver bind
ACTION=="bind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", TEST=="power/control", ATTR{power/control}="auto"
ACTION=="bind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030200", TEST=="power/control", ATTR{power/control}="auto"

# Disable runtime PM for NVIDIA VGA/3D controller devices on driver unbind
ACTION=="unbind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", TEST=="power/control", ATTR{power/control}="on"
ACTION=="unbind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030200", TEST=="power/control", ATTR{power/control}="on"
EOF
        fi
        if pacman -Q switcheroo-control &> /dev/null; then
            log info "Enable switcheroo-control"
            sudo systemctl enable switcheroo-control
        fi
    fi
fi
