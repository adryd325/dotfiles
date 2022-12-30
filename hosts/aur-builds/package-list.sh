#!/usr/bin/env bash
# pacman -Qmq | tr ' ' "\n" | xclip -selection clipboard
# pacman -Slq aur | pacman -Qq - 2>/dev/null | tr ' ' "\n" | xclip -selection clipboard
export PACKAGE_LIST=(
    adw-gtk3-git
    switcheroo-control
    1password
    aseprite
    gnome-browser-connector
    gdm-prime
    gnome-text-editor
    libgdm-prime
    mangohud
    mangohud-common
    mutter-performance
    nvm
    paru
    piavpn-bin
    plymouth
    pnpm
    prismlauncher
    prismlauncher-git
    solo2-cli-git
    touchegg
    visual-studio-code-bin
    imhex
    jetbrains-toolbox
    chromium-snapshot-bin
    insect
    qflipper-git
    spi-ch341-usb-dkms
    chirp-hg
    rpi-imager

    # fonts
    ttf-ipa-mona
    ttf-ms-fonts
    otf-san-francisco-mono
    ttf-unifont
    ocr-fonts
    otf-recursive

    # sdr
    kalibrate-rtl-git
    sdrpp-git
    sdrpp-tetra-demodulator-git

    # nfc
    libfreefare-git
    cardpeek
    mrtdreader
)

export KEYS_TRUST=(
    95D2E9AB8740D8046387FD151A09227B1F435A33 # ttf-unifont
    3FEF9748469ADBE15DA7CA80AC2D62742012EA22 # 1password
    93BDB53CD4EBC740                         # mingw-w64
)
