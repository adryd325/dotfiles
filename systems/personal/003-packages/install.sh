#!/usr/bin/env bash
source $HOME/.adryd/constants.sh
source $AR_DIR/lib/os.sh
source $AR_DIR/lib/tmp.sh
AR_MODULE="packages"

if [ "$AR_OS" == "linux_arch" ]; then
    yay -S --noconfirm --removemake "plymouth-git"
    yay -S --noconfirm --removemake "libgdm-plymouth-prime"
    yay -S --noconfirm --removemake "gdm-plymouth-prime"
    yay -S --noconfirm --removemake "gnome-shell-extensions" "gnome-shell" "chrome-gnome-shell"
fi