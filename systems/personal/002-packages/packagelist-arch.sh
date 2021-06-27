#!/usr/bin/env bash
source $HOME/.adryd/constants.sh
packages=(
    # Extras
    "cups"
    "hplip"
    "networkmanager-openvpn"
    "networkmanager-wireguard-git"
    "touchegg"
    # GNOME base
    "chrome-gnome-shell-git"
    "eog"
    "file-roller"
    "gdm-plymouth-prime"
    "gedit"
    "gnome-backgrounds"
    "gnome-color-manager"
    "gnome-control-center"
    "gnome-font-viewer"
    "gnome-keyring"
    "gnome-screenshot"
    "gnome-session"
    "gnome-settings-daemon"
    "gnome-shell"
    "gnome-shell-extensions-git"
    "gnome-system-monitor"
    "gnome-terminal"
    "gnome-themes-extra"
    "gnome-tweaks"
    "gnome-weather"
    "gvfs"
    "gvfs-afc"
    "gvfs-gphoto2"
    "gvfs-nfs"
    "gvfs-smb"
    "libgdm-plymouth-prime"
    "nautilus"
    "plymouth-git"
    "sushi"
    "totem"
    "tracker"
    "tracker-miners"
    "tracker3"
    "tracker3-miners"
    # Base apps
    "firefox-developer-edition"
    # CLI tools
    "croc"
    "ffmpeg"
    "htop"
    "imagemagick"
    "openbsd-netcat"
    "reflector"
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
    "peek"
    "piavpn-bin" # fuck andrew lee
    "quassel-monolithic"
    "remmina"
    "telegram-desktop"
    "torbrowser-launcher"
    "v4l2loopback-dkms"
    "virt-viewer"
    "visual-studio-code-bin" # microsoft build of vscode. Needed for live-share
    "vlc-luajit"
    "xournalpp"
    # 
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
        "multimc-git"
         # Drivers
        "nvidia"
        "nvidia-prime"
        "nvidia-settings"
        "switcheroo-control"
        # Needed for steam runing with dedicated gpu
        "lib32-nvidia-utils"
        # For /boot-less booting with keyring
        "linux-lts"
        "nvidia-lts"
    )
fi

if [ "$HOSTNAME" == "leaf" ]; then
    packages+=(
        # Drivers
        "qemu-guest-agent"
    )
fi
