#!/usr/bin/env bash
source /home/adryd/.adryd/lib/log.sh
export AR_MODULE=''

gpuVM=1000
VM=$1

if [ "$USER" != "root" ]; then
    log 5 "please run as root"
    exit 1
fi

if [ ! -e /etc/pve/qemu-server/$VM.conf ]; then
    log error "unknown VM: $VM"
    exit 1
fi

if [ "$(qm status $gpuVM)" == "status: running" ]; then
    log info "shutting down $gpuVM"
    qm shutdown $gpuVM || log info "forcing shut down $gpuVM" && qm stop $gpuVM
fi
sleep 1

qm set $gpuVM --onboot 0
qm set $VM --onboot 1 --hostpci0 01:00,pcie=1,x-vga=1 --usb0 host=046d:c332 --usb1 host=046d:c336 --usb2 host=1-9 --usb3 host=2-9 --vga none

qm start $VM
