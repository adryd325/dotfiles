mv /etc/modprobe.d/pcie-passthrough.disabled /etc/modprobe.d/pcie-passthrough.conf
case $1 in 
    "windows")
        VM=1012
        ;;
    "macos")
        VM=1013
        ;;
    "arch" | *)
        VM=1011
        ;;
esac
echo -n "$VM" > /var/activegpuvm
sed -i "s/onboot: 0/onboot: 1/" /etc/pve/qemu-server/$VM.conf
reboot
