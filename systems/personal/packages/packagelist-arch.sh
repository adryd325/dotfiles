#!/usr/bin/env bash
function ucodepkg() {
    cpuType="$(grep vendor_id < /proc/cpuinfo | sed 's/vendor_id\t: //g' | head -1)"
    [[ "${cpuType}" = "GenuineIntel" ]] && printf "intel-ucode"
    [[ "${cpuType}" = "AuthenticAmd" ]] && printf "amd-ucode"
}

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
    "openssh"
    "$(ucodepkg)"

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
    "chromium" # i've given up on firefox, there's a whole list of reasons
    "visual-studio-code-bin" # microsoft build of vscode. Needed for live-share
    # usually a terminal and discord would go here, but those will get installed elsewhere

    # Programming languages and libs
    "go"
    "jdk-openjdk"
    "jdk8-openjdk"
    "nodejs"
    "npm"
    "nvm"
    "pnpm"
    "python"
    "rust"

    # Utilities
    "audacity"
    "cef-minimal"
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
    "remmina"
    "signal-desktop"
    "telegram-desktop"
    "torbrowser-launcher"
    "v4l2loopback-dkms"
    "virt-viewer"
    "vlc-luajit" # dep of obs-studio-browser, need a video player anyways
    "xournalpp"

    # Extras
    "aria2"
    "bash-completion"
    "croc"
    "cups"
    "fd" # find clone
    "ffmpeg"
    "git-crypt"
    "hplip"
    "htop"
    "imagemagick"
    "jack2"
    "jq"
    "mpv"
    "networkmanager-openvpn"
    "networkmanager-wireguard-git"
    "openbsd-netcat"
    "pacman-contrib"
    "pipewire"
    "pipewire-pulse"
    "reflector"
    "ripgrep"
    "sd" # sed clone
    "shellcheck"
    "systemd-resolvconf"
    "tlp"
    "touchegg"
    "unzip"
    "xclip"
    "yt-dlp"
    "zip"

    # Build Tools used frequently by things I use on the AUR
    "cmake"
    "meson"
    "ninja"

    # FONTS!!!
    "cantarell-fonts" # Cantarell
    "gsfonts" # Nimbus Roman
    "noto-fonts" # Noto Serif, Noto Sans, Noto Sans UI, Noto Sans Mono
    "noto-fonts-cjk"
    "noto-fonts-emoji-apple" # Noto Color Emoji
    "ttf-unifont" # Unifont
    # "otf-inter-local" # Inter
    # "otf-recursive-code-local" # Recursive

    # Extra kernel
    "linux-lts"
    "linux-lts-headers"
)

if [[ "${HOSTNAME}" = "popsicle" ]] || [[ "${HOSTNAME}" = "leaf" ]]; then
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

if [[ "${HOSTNAME}" = "popsicle" ]]; then
    packages+=(
        # Games
        "multimc-git"

         # Drivers
        "nvidia"
        "nvidia-lts"
        "nvidia-prime"
        "nvidia-settings"
        "nvidia-utils"
        "lib32-nvidia-utils" # Needed for steam runing with dedicated gpu
        "vulkan-intel"
        "lib32-vulkan-intel"
        "switcheroo-control"
    )
fi

if [[ "${HOSTNAME}" = "leaf" ]]; then
    packages+=(
        # Drivers
        "qemu-guest-agent"
        "spice-vdagent"
        "amdvlk"
        "lib32-amdvlk"
    )
fi

export packages