#!/usr/bin/env bash
# pacman -Qmq | tr ' ' "\n" | xclip -selection clipboard
# pacman -Slq aur | pacman -Qq - 2>/dev/null | tr ' ' "\n" | xclip -selection clipboard
export PACKAGE_LIST=(
    adw-gtk3-git
    auto-cpufreq
    cider
    cider-git
    switcheroo-control
    ttf-unifont
    yaru-sound-theme
    1password
    aseprite
    chrome-gnome-shell
    gdm-prime
    gnome-text-editor
    libgdm-prime
    mangohud
    mangohud-common
    mutter-performance
    nvm
    otf-recursive
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
    binfmt-qemu-static
    qemu-user-static
    kalibrate-rtl-git
)

export KEYS_TRUST=(
    95D2E9AB8740D8046387FD151A09227B1F435A33 # ttf-unifont
    3FEF9748469ADBE15DA7CA80AC2D62742012EA22 # 1password
    CEACC9E15534EBABB82D3FA03353C9CEF108B584 # qemu-user-static
)
