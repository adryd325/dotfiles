#!/usr/bin/env bash
source $HOME/.adryd/constants.sh
source $AR_DIR/lib/os.sh
source $AR_DIR/lib/tmp.sh
AR_MODULE="packages"

brewTaps=("homebrew/cask-versions" "homebrew/cask-drivers" "homebrew/cask-fonts" "jeffreywildman/virt-manager")
brewPackages=(
    # GNU stuff and other CLI tools / libs
    "coreutils" "binutils" "ncurses" "diffutils" "ed" "findutils" "gawk" "gnu-indent" "gnu-sed" "gnu-tar" 
    "gnu-which" "grep" "gzip" "watch" "wget" "bash" "less" "make" "nano" "git" "openssh" "rsync" "unzip" "vim" "zsh"
    "tmux" "curl" "zstd"
    # Programming languages
    "nodejs" "python"
    # CLI tools
    "ffmpeg" "youtube-dl" "htop" "mas"
    # Utilities
    "apptrap" "lulu" "blockblock" "knockknock" "netiquette" "suspicious-package" "keka" "virt-viewer"
    # Base apps
    "firefox" "iterm2" "visual-studio-code" "discord" "discord-canary"
    # Extra
    "tor-browser" "affinity-designer-beta" "adobe-creative-cloud" "font-cascadia-code")
masPackages=("407963104" "1037126344")
packages=(
    # Extras
    "gnu-free-fonts" "cups" "hplip" "networkmanager-openvpn"
    # GNOME base
    "eog" "file-roller" "gedit" "gnome-backgrounds" "gnome-color-manager" "gnome-control-center"
    "gnome-keyring" "gnome-screenshot" "gnome-settings-daemon" "gnome-session" "gnome-software"
    "gnome-terminal" "gnome-themes-extra" "gnome-weather" "gvfs" "gvfs-nfs" "gvfs-smb" "gvfs-gphoto2" "gvfs-afc" "nautilus"
    "sushi" "totem" "tracker" "tracker3" "tracker-miners" "tracker3-miners" "gnome-tweaks"
    "gnome-software-packagekit-plugin" "gnome-system-monitor" "mutter" 
    "plymouth-git" "gdm-plymouth-prime" "libgdm-plymouth-prime" "gnome-shell-extensions" "gnome-shell" "chrome-gnome-shell"
    # Base apps
    "firefox-developer-edition"
    # CLI tools
    "htop" "ffmpeg" "youtube-dl" "openbsd-netcat" "reflector" "croc" "imagemagick"
    # Programming languages
    "nodejs" "npm" "pnpm" "python" "go" "jdk-openjdk" "jdk8-openjdk"
    # Utilities
    "virt-viewer" "remmina" "freerdp" "libvncserver" "keepassxc" "mumble" "torbrowser-launcher" "dconf-editor" "audacity" "inkscape" "gimp"
    "libreoffice-still" "quassel-monolithic" "deluge" "deluge-gtk" "obs-studio-browser" "v4l2loopback-dkms" "vlc-luajit" "telegram-desktop"
    "xournalpp" "peek"
    # Build Tools
    "cmake" "meson" "ninja"
    # Microsoft build of vscode :(
    # Needed for live share
    # Microsoft poopy   
    "visual-studio-code-bin"

fi
)

[ "$HOSTNAME" == "socks" ] \
    && packages+=()

[ "$HOSTNAME" == "popsicle" ] || [ "$HOSTNAME" == "leaf" ] \
    && packages+=(
        "noto-fonts" "otf-san-francisco" "ttf-twemoji-color" "ttf-cascadia-code"
        # Wine
        "wine-staging" "wine-mono" "wine-gecko"
        # Games
        "steam" "powder-toy"
    )

[ "$HOSTNAME" == "popsicle" ] \
    && packages+=(
        "multimc-git"
         # Drivers
        "nvidia" "switcheroo-control" "nvidia-settings"
        # Needed for steam runing with dedicated gpu
        "lib32-nvidia-utils"
        # For /boot-less booting with keyring
        "linux-lts" "nvidia-lts"
)

[ "$HOSTNAME" == "leaf" ] \
    && packages+=(
        # Drivers
        "qemu-guest-agent"
    )

if [ "$AR_OS" == "linux_arch" ]; then
    sudo pacman -Sy
    # Install yay if it's not already installed
    oldPwd="$PWD"
    yayDir="$AR_TMP/$AR_MODULE/yay"
    [[ ! -x "$(command -v yay)" ]] \
        && mkdir -p "$yayDir" \
        && git clone https://aur.archlinux.org/yay.git "$yayDir" \
        && cd "$yayDir" \
        && makepkg -si --noconfirm\
        && cd "$oldPwd"

    # Install everything with yay
    yay -Sy --noconfirm --removemake --useask ${packages[*]}
fi


if [ "$AR_OS" == "darwin_macos" ]; then
    # Install brew if it's not already installed
    [[ ! -x "$(command -v brew)" ]] \
        && log info "Running brew install script" \
        && bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
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
