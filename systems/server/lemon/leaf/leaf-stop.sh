#!/usr/bin/env bash
source /home/adryd/.adryd/constants.sh
export AR_MODULE=''

gpuVM=1000
VM=$1

if [ "$USER" != "root" ]; then
    log error "please run as root"
    exit 1
fi

if [ ! -e /etc/pve/qemu-server/$VM.conf ]; then
    log error "unknown VM: $VM"
    exit 1
fi

if [ "$(qm status $VM)" == "status: running" ]; then
    log info "shutting down $VM"
    qm shutdown $VM || log info "forcing shut down $VM" && qm stop $VM
fi
sleep 1

qm set $gpuVM --onboot 1
qm set $VM --onboot 0 --delete hostpci0,usb0,usb1,usb2,usb3 --vga qxl

qm start $gpuVM
