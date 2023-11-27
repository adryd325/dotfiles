#!/usr/bin/env bash
# pacman -Qmq | tr ' ' "\n" | xclip -selection clipboard
# pacman -Slq aur | pacman -Qq - 2>/dev/null | tr ' ' "\n" | xclip -selection clipboard
export PACKAGE_LIST=(

    1password
    aseprite
    prismlauncher
    mullvad-vpn
    visual-studio-code-bin
    jetbrains-toolbox
    parsec-bin

    qflipper-git
    rpi-imager
    mullvad-browser-bin
    google-cloud-cli

    adw-gtk3-git
    gdm-prime
    libgdm-prime
    mutter-performance
    nvm
    paru
    solo2-cli-git
    insect
    python-pyfuse3
    pkg_scripts

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
    airspyhf-git
    soapysdrplay3-git
    libsdrplay

    # nfc
    libfreefare-git
    cardpeek
    mrtdreader
)

export KEYS_TRUST=(
    95D2E9AB8740D8046387FD151A09227B1F435A33 # ttf-unifont
    3FEF9748469ADBE15DA7CA80AC2D62742012EA22 # 1password
    93BDB53CD4EBC740                         # mingw-w64
    2F391DE6B00D619C                         # mullvad-vpn
    78CEAA8CB72E4467                         # mullvad-vpn
    E53D989A9E2D47BF                         # mullvad-browser-bin
    243ACFA951F78E01                         # python-pyfuse3
    CDBAA37ABC74FBA0                         # simplescreenrecorder
)
