#!/usr/bin/env bash
source $HOME/.adryd/constants.sh
source $AR_DIR/lib/os.sh
source $AR_DIR/lib/node.sh
AR_MODULE="reflector"

if [ "$AR_OS" == "linux_arch" ] && [ "$USER" == "adryd" ] && pacman -Q reflector &> /dev/null; then
    log info "Generating mirror list"
    [ ! -e /etc/pacman.d/mirrorlist.arbak ] && sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.arbak
    reflector --fastest 10 --country CA,US --protocol http,https --connection-timeout 10 --download-timeout 10 --threads 6 --ipv4 --sort rate | sudo tee /etc/pacman.d/mirrorlist
fi