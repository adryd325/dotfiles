#!/usr/bin/env bash
# shellcheck source=../../../constants.sh
[[ -z "${AR_DIR}" ]] && echo "Please set AR_DIR in your environment" && exit 0; source "${AR_DIR}"/constants.sh
ar_os
AR_MODULE="pacman"

if [[ "${AR_OS}" == "linux_arch" ]]; then
    log info "Changing pacman preferences"
    if [[ -f /etc/pacman.conf ]]; then
        [[ ! -e /etc/pacman.conf.orig ]] && sudo cp /etc/pacman.conf /etc/pacman.conf.orig

        log silly "Enable color"
        sudo sed -i "s/^#Color\$/Color/" /etc/pacman.conf
        
        log silly "Enable parallel downloads"
        sudo sed -i "s/^#ParallelDownloads = 5\$/ParallelDownloads = 12/" /etc/pacman.conf
        
        if ! grep "# .ADRYD LOCK (${AR_MODULE})" /etc/pacman.conf > /dev/null; then
            sudo tee -a /etc/pacman.conf > /dev/null <<EOF
# .ADRYD LOCK (${AR_MODULE}) (this is to prevent the deploy script from infinitely appending this config to the end of the file)
[multilib]
Include = /etc/pacman.d/mirrorlist
[aur]
Server = https://aur.coolmathgames.tech
EOF
            log info "Enable multilib"
        fi
    fi
    if [[ -f /etc/makepkg.conf ]]; then
        [[ ! -e /etc/makepkg.conf.orig ]] && sudo cp /etc/makepkg.conf /etc/makepkg.conf.orig
        if ! grep "# .ADRYD LOCK (${AR_MODULE})" /etc/makepkg.conf > /dev/null; then
            sudo tee -a /etc/makepkg.conf > /dev/null <<EOF
# .ADRYD LOCK (${AR_MODULE}) (this is to prevent the deploy script from infinitely appending this config to the end of the file)
COMMON_FLAGS="-march=native -mtune=native -O2 -pipe -fno-plt -fexceptions -Wp,-D_FORTIFY_SOURCE=2 -Wformat -Werror=format-security -fstack-clash-protection -fcf-protection"
CFLAGS="\${COMMON_FLAGS}"
CXXFLAGS="\${COMMON_FLAGS} -Wp,-D_GLIBCXX_ASSERTIONS"
RUSTFLAGS="-C opt-level=2 -C target-cpu=native"
MAKEFLAGS="-j\$(expr \$(nproc) - 2)"
EOF
            log info "Apply custom compiler args"
        fi
    fi

    log info "Trusting Mary's AUR repo keys"
    sudo pacman-key --add "${AR_DIR}/systems/personal/${AR_MODULE}/mary-aur.key" &> /dev/null
    sudo pacman-key --lsign-key 4338A0E98FE8718EA718126FD8A8A0C4D0CE4C1E &> /dev/null

    log info "Add pacman hooks"
    sudo mkdir -p "/etc/pacman.d/hooks"
    sudo cp -f "${AR_DIR}/systems/personal/${AR_MODULE}/10-backup-modules.hook" "/etc/pacman.d/hooks"
    sudo cp -f "${AR_DIR}/systems/personal/${AR_MODULE}/10-restore-modules.hook" "/etc/pacman.d/hooks"
    sudo cp -f "${AR_DIR}/systems/personal/${AR_MODULE}/100-systemd-boot.hook" "/etc/pacman.d/hooks"
    sudo cp -f "${AR_DIR}/systems/personal/${AR_MODULE}/100-hidden-apps.hook" "/etc/pacman.d/hooks"
    sudo cp -f "${AR_DIR}/systems/personal/${AR_MODULE}/100-pacman-cache-cleanup.hook" "/etc/pacman.d/hooks"

    if [[ "${USER}" = "adryd" ]] && [[ -e /etc/pacman.d/mirrorlist ]]; then
        # this doesn't apply outside of my area
        [[ ! -e /etc/pacman.d/mirrorlist.orig ]] && sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.orig
        sudo cp -f "${AR_DIR}/systems/personal/${AR_MODULE}/preferred-mirrorlist" /etc/pacman.d/mirrorlist
    fi
fi
