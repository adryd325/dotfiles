packages=(
    # BASE
    "linux"
    "linux-firmware"
    "linux-headers"
    "base"
    "base-devel"
    "man-db"
    "man-pages"
    "btrfs-progs"
    "networkmanager"
    "neovim"
    "git"
    "pacman"

    # Extras
    "cups"
    "hplip"
    "jack2"
    "networkmanager-openvpn"
    "networkmanager-wireguard-git"
    "pacman-contrib"
    "systemd-resolvconf"
    "touchegg"

    # GNOME
    "baobab"
    "chrome-gnome-shell"
    "eog"
    "file-roller"
    "gdm-plymouth-prime"
    "gnome-backgrounds"
    "gnome-color-manager"
    "gnome-control-center"
    "gnome-font-viewer"
    "gnome-keyring"
    "gnome-screenshot"
    "gnome-session"
    "gnome-settings-daemon"
    "gnome-shell"
    "gnome-shell-extensions"
    "gnome-system-monitor"
    "gnome-terminal"
    "gnome-themes-extra"
    "gnome-text-editor"
    "gnome-tweaks"
    "gnome-weather"
    "gvfs"
    "gvfs-afc"
    "gvfs-gphoto2"
    "gvfs-nfs"
    "gvfs-smb"
    "libgdm-plymouth-prime"
    "nautilus"
    "plymouth"
    "sushi"
    "totem"
    "tracker"
    "tracker-miners"
    "tracker3"
    "tracker3-miners"

    # Base apps
    "firefox-developer-edition"
    "visual-studio-code-bin" # microsoft build of vscode. Needed for live-share
    # usually a terminal and discord would go here, but those will get installed elsewhere

    # CLI tools
    "croc"
    "ffmpeg"
    "htop"
    "imagemagick"
    "openbsd-netcat"
    "reflector"
    "xclip"
    "youtube-dl"

    # Programming languages and libs
    "go"
    "jdk-openjdk"
    "jdk8-openjdk"
    "nodejs"
    "npm"
    "pnpm"
    "python"

    # Utilities
    "audacity"
    "cef-minimal"
    "chromium"
    "dconf-editor"
    "deluge"
    "deluge-gtk"
    "freerdp" # for remmina
    "gimp"
    "gnome-calculator"
    "gnome-calendar"
    "gnome-contacts"
    "gnome-system-monitor"
    "inkscape"
    "keepassxc"
    "libreoffice-still"
    "libvncserver" # for remmina
    "mesa-demos"
    "mumble"
    "obs-studio-browser"
    "pavucontrol"
    "peek"
    "piavpn-bin" # fuck andrew lee
    "quassel-monolithic"
    "remmina"
    "telegram-desktop"
    "torbrowser-launcher"
    "v4l2loopback-dkms"
    "virt-viewer"
    "vlc-luajit"
    "xournalpp"

    # Build Tools used frequently by things I use on the AUR
    "cmake"
    "meson"
    "ninja"

    # FONTS!!!
    "noto-fonts"
    "noto-fonts-cjk"
    "noto-fonts-emoji-apple"
    "otf-san-francisco"
    "ttf-cascadia-code"
    "ttf-dejavu"
    "ttf-ms-fonts"
    "ttf-unifont"
)

if [ "$HOSTNAME" == "popsicle" ] || [ "$HOSTNAME" == "leaf" ]; then
    packages+=(
        # Wine
        "wine-gecko"
        "wine-mono" 
        "wine-staging" 

        # Games
        "powder-toy"
        "steam" 
    )
fi

if [ "$HOSTNAME" == "popsicle" ]; then
    packages+=(
        # Games
        "multimc-git"

         # Drivers
        "nvidia"
        "nvidia-prime"
        "nvidia-settings"
        "nvidia-utils"
        "vulkan-intel"
        "lib32-vulkan-intel"
        "switcheroo-control"
        "lib32-nvidia-utils" # Needed for steam runing with dedicated gpu
    )
fi

if [ "$HOSTNAME" == "leaf" ]; then
    packages+=(
        # Drivers
        "qemu-guest-agent"
        "amdvlk"
        "lib32-amdvlk"
    )
fi
