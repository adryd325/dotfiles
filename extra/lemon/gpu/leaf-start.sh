#!/bin/bash
if [[ $USER == "root" ]]; then
    mv /etc/modprobe.d/pcie-passthrough.disabled /etc/modprobe.d/pcie-passthrough.conf
    case $1 in 
        "windows" | "1011")
            VM=1011
            ;;
        "macos" | "1012")
            VM=1012
            ;;
        "arch" | "1010" | *)
            VM=1010
            ;;
    esac
    echo -n "$VM" > /var/activegpuvm
    sed -i "s/onboot: 0/onboot: 1/" /etc/pve/qemu-server/$VM.conf
    cat /etc/pve/qemu-server/$VM.conf | grep "\[PENDING\]"
    [[ ! $? -eq 0 ]] && echo "[PENDING]" >> /etc/pve/qemu-server/$VM.conf
    echo "hostpci0: 01:00,pcie=1,x-vga=1" >> /etc/pve/qemu-server/$VM.conf
    echo "usb0: host=1-13.1.2" >> /etc/pve/qemu-server/$VM.conf
    echo "usb1: host=1-13.1.3" >> /etc/pve/qemu-server/$VM.conf
    echo "vga: none" >> /etc/pve/qemu-server/$VM.conf
    reboot
else
    echo "Please run as root"
fi