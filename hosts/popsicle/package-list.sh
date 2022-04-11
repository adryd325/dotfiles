#!/usr/bin/env bash

packages=(
    # BASE
    "linux"
    "linux-firmware"
    "linux-headers"
    "intel-ucode"
    "base"
    "base-devel"
    "man-db"
    "man-pages"
    "paru"
    "btrfs-progs"
    "networkmanager"
    "sudo"
    "nano"
    "git"
    "pacman"
    "openssh"

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
    "gnome-session"
    "gnome-settings-daemon"
    "gnome-shell"
    "gnome-shell-extensions"
    "gnome-software"
    "gnome-system-monitor"
    "gnome-text-editor"
    "gnome-tweaks"
    "gnome-weather"
    "gvfs"
    gvfs-{afc,gphoto2,nfs,smb}
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
    "gnome-terminal"
    "firefox-developer-edition"
    "visual-studio-code-bin" # microsoft build of vscode. Needed for live-share
    "1password"

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
    "cider-git"
    "celluloid"
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
    "helvum"
    "inkscape"
    "intellij-idea-community-edition"
    "kcharselect"
    "keepassxc"
    kicad{,-library{,-3d}}
    "libvncserver" # for remmina
    "mesa-demos"
    "mumble"
    "nicotine+"
    "obs-studio"
    "pavucontrol"
    "piavpn-bin"
    "remmina"
    "signal-desktop"
    "telegram-desktop"
    "torbrowser-launcher"
    "v4l2loopback-dkms"
    "virt-viewer"
    "xournalpp"
    "flatpak"

    # Extras
    "aria2"
    "asar"
    "auto-cpufreq"
    "bash-completion"
    "borg"
    "cdrtools"
    "croc"
    "cups"
    "direnv"
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
    "jq"
    "libfido2"
    "mangohud"
    "mesa-utils"
    "mesa-demos"
    "neofetch"
    "neovim"
    "networkmanager-openvpn"
    "ntfs-3g"
    "openbsd-netcat"
    "pacman-contrib"
    "perl-authen-sasl" # git-send-email
    "perl-io-socket-ssl" # git-send-email
    "pipewire"
    "pipewire-pulse"
    "pipewire-jack"
    "reflector"
    "ripgrep"
    "sd" # sed clone
    "shellcheck"
    "solo2-cli-git"
    "strace"
    "systemd-resolvconf"
    "thermald"
    "the_silver_searcher"
    "traceroute"
    "touchegg"
    "unzip"
    "veracrypt"
    "wireguard-tools"
    "wireplumber"
    "xclip"
    "xorg-xkill"
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
    "inter-font" # Inter
    "gsfonts" # Nimbus Roman
    "noto-fonts" # Noto Serif, Noto Sans, Noto Sans UI, Noto Sans Mono
    "noto-fonts-cjk"
    "noto-fonts-emoji" # Noto Color Emoji
    "ttf-unifont" # Unifont
    "ttf-ipa-mona"
    "ttf-ms-fonts"
    "ttf-windows"
    "ttf-ibm-plex"
    "otf-recursive" # Recursive

    # Extra kernel
    "linux-lts"
    "linux-lts-headers"

    # Wine
    "wine-gecko"
    "wine-mono"
    "wine-staging"

    # Games
    "steam"
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
    "intel-media-driver"
    "switcheroo-control"
    "cuda"
    "fprintd"

    # VM stuff
    "virt-manager"
    "binfmt-qemu-static"
    "qemu"
    "qemu-arch-extra"
    "qemu-user-static"
    "dnsmasq"
    "edk2-ovmf"
    "edk2-armvirt"
    "swtpm"

    # SDR stuff
    "rtl-sdr"
)

flatpaks=(
    "net.blockbench.Blockbench"
    "com.github.tchx84.Flatseal"
    "de.haekerfelix.Fragments"
    "re.sonny.Junction"
    "com.belmoussaoui.Obfuscate"
    "com.parsecgaming.parsec"
    "uk.co.powdertoy.tpt"
    "org.gnome.SoundRecorder"
)

export packages
export flatpaks
export flatpaksGnomeNightly
