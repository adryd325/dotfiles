#!/usr/bin/env bash
# shellcheck source=../../../constants.sh
[[ -z "${AR_DIR}" ]] && echo "Please set AR_DIR in your environment" && exit 0; source "${AR_DIR}"/constants.sh
ar_os
ar_tmp
AR_MODULE="packages"

#if [[ "${AR_OS}" = "linux_archlinux" ]]; then
    # shellcheck source=../packages/packagelist-arch.sh
    source "${AR_DIR}/legacy/personal/${AR_MODULE}/packagelist-arch.sh"
    sudo pacman -Syu
    # Install paru if it's not already installed
    oldPwd="${PWD}"
    paruDir="${AR_TMP}/${AR_MODULE}/paru"
    if grep "aur.coolmathgames.tech" /etc/pacman.conf &> /dev/null; then
        sudo pacman -S paru --noconfirm
    elif [[ ! -x "$(command -v paru)" ]]; then
        mkdir -p "${paruDir}"
        log verb "Cloning paru"
        git clone https://aur.archlinux.org/paru.git "${paruDir}" --quiet
        cd "${paruDir}" || return
        log verb "Building paru"
        makepkg -si --noconfirm
        cd "${oldPwd}" || return
    fi

    # Add keyserver
    if ! grep "keyserver hkps://keyserver.ubuntu.com" "${HOME}/.gnupg/gpg.conf" &> /dev/null; then
        log info "Adding gpg keyserver"
        mkdir -p "${HOME}/.gnupg"
        echo "keyserver hkps://keyserver.ubuntu.com" >> "${HOME}/.gnupg/gpg.conf"
    fi

    # Install everything with paru
    paru -Sy --noconfirm --useask --asexplicit --removemake "${packages[@]}"

    if pacman -Q flatpak &> /dev/null; then
        log info "Installing flatpaks"
        flatpak remote-add --if-not-exists gnome-nightly https://nightly.gnome.org/gnome-nightly.flatpakrepo
        flatpak install "${flatpaks[@]}" -y
        flatpak install "${flatpaksGnomeNightly[@]}" -y
    fi
#fi


if [[ "${AR_OS}" = "darwin_macos" ]]; then
    # shellcheck source=../packages/packagelist-macos.sh
    source "${AR_DIR}/legacy/personal/${AR_MODULE}/packagelist-macos.sh"
    # Install brew if it's not already installed
    if [[ ! -x "$(command -v brew)" ]]; then
        log info "Running brew install script"
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    log info "Updating brew"
    brew update --quiet &> /dev/null

    for tap in "${brewTaps[@]}"; do
        log info "Tapping ${tap}"
        brew tap "${tap}" --quiet > /dev/null
    done

    for package in "${brewPackages[@]}"; do
        # listCache exists for the sole reason that brew is slow. We get a list once, and if we haven't installed a new
        # package, we don't have to refresh it!
        [[ -z "${listCache}" ]] && listCache=$(brew list)
        if echo "${listCache}" | grep "^${package}$/" > /dev/null; then 
            log verb "Skipped installing ${package}, It's already installed"
        else             
            log info "Installing ${package} with Homebrew"
            brew install "${package}" --quiet > /dev/null || log warn "Installation failed for ${package}"
            listCache=$(brew list)
            log silly Updated package list cache  
        fi
    done

    if ! mas account &> /dev/null; then
        log ask "Please sign into the App Store and press any key to continue"
        read -r
    fi

    if mas account &> /dev/null; then
        for package in "${masPackages[@]}"; do
            prettyName="$(mas info "${package}" 2> /dev/null | head -1 | sed 's/ [0-9.]* [[0-9.]*\]$//') (${package})"
            if ! mas list | grep -w "${package}" > /dev/null; then
                log info "Installing ${prettyName} from the App Store"
                mas install "${package}" > /dev/null || log warn "Installation failed for ${prettyName}"
            else
                log verb "Skipped installing ${prettyName}, It's already installed"
            fi
        done
    fi
fi
