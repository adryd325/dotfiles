#!/bin/bash
export AR_DOTFILES_DIR=~/.adryd

# detect archiso and run archiso scripts
if lsblk -o name,mountpoint | grep 'loop0 *\/run/archiso/sfs/airootfs$'; then
    ./opt/archinstall/archiso.sh
fi