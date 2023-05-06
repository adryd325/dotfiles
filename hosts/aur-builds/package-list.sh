#!/usr/bin/env bash
# pacman -Qmq | tr ' ' "\n" | xclip -selection clipboard
# pacman -Slq aur | pacman -Qq - 2>/dev/null | tr ' ' "\n" | xclip -selection clipboard
export PACKAGE_LIST=(

    1password
    aseprite
    prismlauncher
    prismlauncher-git
    piavpn-bin
    visual-studio-code-bin
    jetbrains-toolbox

    qflipper-git
    rpi-imager

    adw-gtk3-git
    switcheroo-control
    gnome-browser-connector
    gdm-prime
    libgdm-prime
    nvm
    paru
    pnpm
    plymouth
    solo2-cli-git
    touchegg
    insect

    mangohud
    mangohud-common

    # radio
    spi-ch341-usb-dkms
    qdmr-git

    # wifi dongle
    rtl8812au-dkms-git

    # fonts
    ttf-ipa-mona
    ttf-ms-fonts
    otf-san-francisco-mono
    ttf-unifont
    ocr-fonts

    # sdr
    kalibrate-rtl-git
    sdrpp-git
    sdrpp-headers-git
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
