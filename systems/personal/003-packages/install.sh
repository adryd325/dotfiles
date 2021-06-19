#!/usr/bin/env bash
source $HOME/.adryd/constants.sh
source $AR_DIR/lib/os.sh
source $AR_DIR/lib/tmp.sh
AR_MODULE="packages"

if [ "$AR_OS" == "linux_arch" ]; then
    yay -S "plymouth-git"
    yay -S "gdm-plymouth-prime" "libgdm-plymouth-prime"
    yay -S "gnome-shell-extensions"
fi