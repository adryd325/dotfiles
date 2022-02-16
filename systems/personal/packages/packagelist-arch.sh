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
    "paru"
    "btrfs-progs"
    "networkmanager"
    "nano"
    "git"
    "pacman"
    "openssh"
    "$(ucodepkg)"

    # GNOME
    "adwaita-icon-theme"
    "baobab"
    "chrome-gnome-shell"
    "eog"
    "file-roller"
    "gdm-prime"
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
    "gnome-software"
    "gnome-software-packagekit-plugin"
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
    "libgdm-prime"
    "mutter-performance"
    "nautilus"
    "plymouth"
    "sushi"
    "totem"
    "tracker"
    "tracker-miners"
    "tracker3"
    "tracker3-miners"
    "xdg-desktop-portal-gnome"

    # Base apps
    "firefox-developer-edition"
    "visual-studio-code-bin" # microsoft build of vscode. Needed for live-share
    "1password"
    # usually a terminal and discord would go here, but those will get installed elsewhere

    # Programming languages and libs
    "jdk-openjdk"
    "jdk11-openjdk"
    "jdk8-openjdk"
    "nodejs"
    "npm"
    "nvm"
    "pnpm"
    "python"
    "rustup"

    # General use desktop apps
    "aseprite"
    "blender"
    "cider"
    "chromium"
    "dconf-editor"
    "easyeffects"
    "freerdp" # for remmina
    "geary"
    "gimp"
    "gnome-calculator"
    "gnome-calendar"
    "gnome-contacts"
    "gnome-system-monitor"
    "inkscape"
    "intellij-idea-community-edition"
    "keepassxc"
    "libreoffice-still"
    "libvncserver" # for remmina
    "mesa-demos"
    "mumble"
    "nicotine+"
    "obs-studio"
    "piavpn-bin"
    "quodlibet"
    "remmina"
    "signal-desktop"
    "telegram-desktop"
    "torbrowser-launcher"
    "v4l2loopback-dkms"
    "virt-viewer"
    "xournalpp"
    "yubioath-desktop"
    "flatpak"

    # Extras
    "aria2"
    "asar"
    "bash-completion"
    "cdrtools"
    "croc"
    "cups"
    "electron"
    "espeak-ng"
    "exfatprogs"
    "fd" # find clone
    "ffmpeg"
    "fwupd"
    "git-crypt"
    "hplip"
    "htop"
    "imagemagick"
    "inetutils"
    "jack2"
    "jq"
    "mesa-utils"
    "mesa-demos"
    "neovim"
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
    "solo2-cli-git"
    "systemd-resolvconf"
    "thermald"
    "traceroute"
    "touchegg"
    "unzip"
    "veracrypt"
    "wireplumber"
    "xclip"
    "yt-dlp"
    "zip"

    # Theming
    "adw-gtk3-git"
    "breeze-icons"
    "breeze"
    "qt5ct" # Make QT apps not look awful
    "yaru-sound-theme"

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
    "ttf-ipa-mona"
    "ttf-ms-fonts"
    "ttf-windows"
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
        "steam" 
    )
fi

if [[ "${HOSTNAME}" = "popsicle" ]]; then
    packages+=(
        # Games
        "polymc"

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
        "cuda"
        "fprintd"

        # VM stuff
        "virt-manager"
        "qemu"
        "dnsmasq"
        "edk2-ovmf"
        "swtpm"

        # Windows dual boot
        "ntfs-3g"
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

flatpaks=(
    "net.blockbench.Blockbench"
    "io.github.celluloid_player.Celluloid"
    "com.github.tchx84.Flatseal"
    "de.haekerfelix.Fragments"
    "re.sonny.Junction"
    "io.gitub.seadve.Kooha"
    "com.belmoussaoui.Obfuscate"
    "com.parsecgaming.parsec"
    "uk.co.powdertoy.tpt"
    "org.gnome.SoundRecorder"
)

flatpaksGnomeNightly=(
    "org.gnome.TextEditor.Devel"
)

export packages
export flatpaks
export flatpaksGnomeNightly
