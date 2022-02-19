#!/usr/bin/env bash
# pacman -Qmq | tr ' ' "\n" | xclip -selection clipboard
# pacman -Slq aur | pacman -Qq - 2>/dev/null | tr ' ' "\n" | xclip -selection clipboard
export PACKAGE_LIST=(
    adw-gtk3-git
    cider
    switcheroo-control
    ttf-unifont
    yaru-sound-theme
    1password
    aseprite
    chrome-gnome-shell
    espeak
    gdm-prime
    libgdm-prime
    mutter-performance
    networkmanager-wireguard-git
    noto-fonts-emoji-apple
    nvm
    paru
    piavpn-bin
    plymouth
    pnpm
    polymc
    solo2-cli-git
    touchegg
    ttf-ipa-mona
    ttf-ms-fonts
    ttf-windows
    visual-studio-code-bin
)

export KEYS_TRUST=(
    95D2E9AB8740D8046387FD151A09227B1F435A33 # ttf-unifont
    3FEF9748469ADBE15DA7CA80AC2D62742012EA22 # 1password
)