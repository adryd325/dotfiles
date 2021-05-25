#!/bin/bash
source $HOME/.adryd/constants.sh
source $AR_DIR/lib/os.sh
source $AR_DIR/lib/node.sh
AR_MODULE="pacman"

if [ "$AR_OS" == "linux_arch" ]; then
    log info "Changing pacman preferences"
    log silly "Enable color"
    [ ! -e /etc/pacman.conf.arbak ] && sudo cp /etc/pacman.conf /etc/pacman.conf.arbak
    sudo sed -i "s/^#Color\$/Color/" /etc/pacman.conf
    log silly "Enable multilib"
    # I fucking hate shell scripting i am on the verge of tears just let me FUCKING REPLACE MULTILINE IN A FILE WITHOUT
    # COMPLICATED FUCKERY HOLY SHIT FUCK BITCH DIE ok i need to not fucking die here please
    sudo $AR_NODE -e "
        const fs = require('fs');
        let pacmanConfig = fs.readFileSync('/etc/pacman.conf','utf-8');
        pacmanConfig = pacmanConfig.replace(
            '#[multilib]\n#Include = /etc/pacman.d/mirrorlist',
            '[multilib]\nInclude = /etc/pacman.d/mirrorlist'
        );
        fs.writeFileSync('/etc/pacman.conf', pacmanConfig);
    "
    [ ! -e /etc/makepkg.conf.arbak ] && sudo cp /etc/makepkg.conf /etc/makepkg.conf.arbak
    log info "Fixing makepkg compiler args"
    log silly "CFLAGS"
    sudo sed -i 's|CFLAGS="-march=x86-64 -mtune=generic -O2 -pipe -fno-plt"|CFLAGS="-march=native -O3 -pipe -fno-plt"|' /etc/makepkg.conf
    log silly "CXXFLAGS"
    sudo sed -i 's|CXXFLAGS="-march=x86-64 -mtune=generic -O2 -pipe -fno-plt"|CXXFLAGS="-march=native -O3 -pipe -fno-plt"|' /etc/makepkg.conf
    log silly "RUSTFLAGS"
    sudo sed -i 's|#RUSTFLAGS="-C opt-level=2"|RUSTFLAGS="-C opt-level=2 -C target-cpu=native"|' /etc/makepkg.conf
    log silly "MAKE"
    sudo sed -i 's|#MAKEFLAGS="-j2"|MAKEFLAGS="-j$(expr $(nproc) - 2)"|' /etc/makepkg.conf
fi
