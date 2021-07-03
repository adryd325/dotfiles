#!/usr/bin/env bash
source $HOME/.adryd/constants.sh
source $AR_DIR/lib/os.sh
AR_MODULE="plymouth"

if [ "$AR_OS" == "linux_arch" ]; then
    sudo sed -i "s/loglevel=3 rd.udev.log_priority=3/quiet splash vt.global_cursor_default=0/" /boot/loader/entries/archlinux.conf \
        && log info "Modifying boot args" # only log if successful, cause uh, we dont do this every time
    log info "Adding mkinitcpio hook"
    [ ! -e "/etc/mkinitcpio.conf.$AR_MODULE.arbak" ] && sudo cp /etc/mkinitcpio.conf "/etc/mkinitcpio.conf.$AR_MODULE.arbak"
    if ! grep "# .ADRYD LOCK ($AR_MODULE)" /etc/mkinitcpio.conf > /dev/null; then
        sudo tee -a /etc/mkinitcpio.conf > /dev/null <<EOF
# .ADRYD LOCK (plymouth) (this is to prevent the deploy script from infinitely appending this config to the end of the file)
HOOKS+=(sd-plymouth)
EOF
    fi
    log info "Applying config"
    [ ! -e /etc/plymouth/plymouthd.conf.arbak ] && sudo cp /etc/plymouth/plymouthd.conf /etc/plymouth/plymouthd.conf.arbak
    sudo tee /etc/plymouth/plymouthd.conf > /dev/null <<EOF
[Daemon]
Theme=bgrt
ShowDelay=0
DeviceTimeout=8
EOF
    log info "Regenerating initramfs"
    sudo mkinitcpio -P
fi  