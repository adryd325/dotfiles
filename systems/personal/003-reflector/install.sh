#!/bin/bash
source $HOME/.adryd/constants.sh
source $AR_DIR/lib/os.sh
source $AR_DIR/lib/node.sh
AR_MODULE="reflector"

if [ "$AR_OS" == "linux_arch" ] && pacman -Q reflector &> /dev/null; then
    log info "Generating mirror list"
    [ ! -e /etc/pacman.d/mirrorlist.arbak ] && sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.arbak
    reflector -f 10 -c CA -p https --ipv4 | sudo tee /etc/pacman.d/mirrorlist > /dev/null
fi