#!/bin/bash
if [[ "$2" == 'post-start' ]] && [[ -e /var/activegpuvm ]] && [[ "$(cat /var/activegpuvm)" == "$1" ]]; then
    mv /etc/modprobe.d/pcie-passthrough.conf /etc/modprobe.d/pcie-passthrough.disabled
    VM=$(cat /var/activegpuvm)
    sed -i "s/onboot: 1/onboot: 0/" /etc/pve/qemu-server/$VM.conf
    cat /etc/pve/qemu-server/$VM.conf | grep "\[PENDING\]"
    [[ ! $? -eq 0 ]] && echo "[PENDING]" >> /etc/pve/qemu-server/$VM.conf
    echo "delete: hostpci0,usb0,usb1" >> /etc/pve/qemu-server/$VM.conf
    [[ "$VM" != '1012' ]] && echo "vga: qxl" >> /etc/pve/qemu-server/$VM.conf
    [[ "$VM" == '1012' ]] && echo "vga: vmware" >> /etc/pve/qemu-server/$VM.conf
    rm /var/activegpuvm
fi
