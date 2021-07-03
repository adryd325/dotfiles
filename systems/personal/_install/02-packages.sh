#!/usr/bin/env bash
source $HOME/.adryd/constants.sh
source $AR_DIR/lib/os.sh
source $AR_DIR/lib/tmp.sh
AR_MODULE="packages"

if [ "$AR_OS" == "linux_arch" ]; then
    source "$AR_DIR/systems/personal/$AR_MODULE/packagelist-arch.sh"
    sudo pacman -Syu
    # Install paru if it's not already installed
    oldPwd="$PWD"
    paruDir="$AR_TMP/$AR_MODULE/paru"
    if [ ! -e "$(command -v paru)" ]; then
        [ -e "$paruDir" ] && rm -r "$paruDir"
        mkdir -p "$paruDir"
        git clone https://aur.archlinux.org/paru.git "$paruDir"
        cd "$paruDir"
        makepkg -si --noconfirm
        cd "$oldPwd"
    fi

    # Install everything with paru
    paru -Sy ${packages[*]}
fi


if [ "$AR_OS" == "darwin_macos" ]; then
    source "$AR_DIR/systems/personal/$AR_MODULE/packagelist-macos.sh"
    # Install brew if it's not already installed
    if [ ! -e "$(command -v brew)" ]; then
        log info "Running brew install script"
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    log info "Updating brew"
    brew update --quiet &> /dev/null

    for tap in "${brewTaps[@]}"; do
        log info "Tapping $tap"
        brew tap $tap --quiet > /dev/null
    done

    for package in "${brewPackages[@]}"; do
        # listCache exists for the sole reason that brew is slow. We get a list once, and if we haven't installed a new
        # package, we don't have to refresh it!
        [ ! "$listCache" ] && listCache=`brew list`
        if echo "$listCache" | grep "^$package$/" > /dev/null; then 
            log info "Installing $package with Homebrew"
            brew install "$package" --quiet > /dev/null || log warn "Installation failed for $package"
            listCache=`brew list`
            log silly Updated package list cache
        else 
            log verb "Skipped installing $package, It's already installed"
        fi
    done

    if ! mas account &> /dev/null; then
        log ask "Please sign into the App Store and press any key to continue"
        read
    fi

    if mas account &> /dev/null; then
        for package in "${masPackages[@]}"; do
            prettyName="`mas info "$package" 2> /dev/null | head -1 | sed 's/ [0-9.]* [[0-9.]*\]$//'` ($package)"
            if ! mas list | grep -w $package > /dev/null; then
                log info "Installing $prettyName from the App Store"
                mas install $package > /dev/null || log warn "Installation failed for $prettyName"
            else
                log verb "Skipped installing $prettyName, It's already installed"
            fi
        done
    fi
fi
