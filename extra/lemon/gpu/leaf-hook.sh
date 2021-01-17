#!/usr/bin/env bash
if [[ "$2" == "pre-start" ]] && [[ -e /var/activegpuvm ]]; then
    mv /etc/modprobe.d/pcie-passthrough.conf /etc/modprobe.d/pcie-passthrough.disabled
    sed -i "s/onboot: 1/onboot: 0/g" /etc/pve/qemu-server/$(cat /var/activegpuvm).conf
    rm /var/activegpuvm
fi
