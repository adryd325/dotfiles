#!/usr/bin/env bash
[[ -z "$AR_DIR" ]] && echo "Please set AR_DIR in your environment" && exit 0; source $AR_DIR/constants.sh
ar_os
AR_MODULE="paru"

if [ "$AR_OS" == "linux_arch" ]; then
    log info "Changing pacman preferences"
    [ ! -e /etc/paru.conf.arbak ] && sudo cp /etc/paru.conf /etc/paru.conf.arbak
    log silly "Enable RemoveMake"
    sudo sed -i "s/^#RemoveMake\$/RemoveMake/" /etc/pacman.conf
    log silly "Enable CleanAfter"
    sudo sed -i "s/^#CleanAfter\$/CleanAfter/" /etc/pacman.conf
    if ! grep "# .ADRYD LOCK ($AR_MODULE)" /etc/pacman.conf > /dev/null; then
        sudo tee -a /etc/pacman.conf > /dev/null <<EOF
# .ADRYD LOCK ($AR_MODULE) (this is to prevent the deploy script from infinitely appending this config to the end of the file)
[multilib]
Include = /etc/pacman.d/mirrorlist
EOF
        log info "Enable multilib"
    fi
    [ ! -e /etc/makepkg.conf.arbak ] && sudo cp /etc/makepkg.conf /etc/makepkg.conf.arbak
    if ! grep "# .ADRYD LOCK ($AR_MODULE)" /etc/makepkg.conf > /dev/null; then
        sudo tee -a /etc/makepkg.conf > /dev/null <<EOF
# .ADRYD LOCK ($AR_MODULE) (this is to prevent the deploy script from infinitely appending this config to the end of the file)
COMMON_FLAGS="-march=native -mtune=native -O2 -pipe -fno-plt -fexceptions -Wp,-D_FORTIFY_SOURCE=2 -Wformat -Werror=format-security -fstack-clash-protection -fcf-protection"
CFLAGS="\${COMMON_FLAGS}"
CXXFLAGS="\${COMMON_FLAGS} -Wp,-D_GLIBCXX_ASSERTIONS"
RUSTFLAGS="-C opt-level=2 -C target-cpu=native"
MAKEFLAGS="-j\$(expr \$(nproc) - 2)"
EOF
        log info "Apply custom compiler args"
    fi
    if [ "$USER" = "adryd" ]; then
        # this doesn't apply outside of my area
        [ ! -e /etc/pacman.d/mirrorlist.arbak ] && sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.arbak
        sudo cp -f "$AR_DIR/systems/personal/$AR_MODULE/preferred-mirrorlist" /etc/pacman.d/mirrorlist
    fi
fi
