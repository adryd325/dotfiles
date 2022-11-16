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
    "chrome-gnome-shell"
    "gdm-prime"
    "gnome-backgrounds"
    "gnome-color-manager"
    "gnome-control-center"
    "gnome-keyring"
    "gnome-session"
    "gnome-settings-daemon"
    "gnome-shell"
    "gvfs"
    gvfs-{afc,gphoto2,nfs,smb}
    "libgdm-prime"
    "mutter"
    "plymouth"
    "sushi"
    "tracker"
    "tracker-miners"
    "tracker3"
    "tracker3-miners"
    "xdg-desktop-portal-gnome"

    # Programming languages and libs
    "jdk-openjdk"
    "jdk17-openjdk"
    "jdk11-openjdk"
    "jdk8-openjdk"
    "nodejs"
    "npm"
    "nvm"
    "pnpm"
    "python"
    "python-pip"
    "rustup"

    # Unsorted
    "mesa-demos"
    "v4l2loopback-dkms"
    "flatpak"
    "aria2"
    "asar"
    "bash-completion"
    "borg"
    "croc"
    "cups"
    "hplip"
    "direnv"
    "electron"
    "espeak-ng"
    "fwupd"
    "git-crypt"
    "htop"
    "jq"
    "mangohud"
    "mesa-utils"
    "mesa-demos"
    "acpi_call-dkms"
    "neofetch"
    "neovim"
    "shellcheck"
    "strace"
    "thermald"
    "auto-cpufreq"
    "perl-authen-sasl" # git-send-email
    "perl-io-socket-ssl" # git-send-email
    "touchegg"

    # Uncategorized gui tools
    "nicotine+" # soulseek client
    "obs-studio"
    "dconf-editor"
    "easyeffects"
    "gnome-calculator"
    "kcharselect" # better unicode char map
    "veracrypt" # multiplatform drive encryption tool
    #"celluloid" # Video player based on mpv
    "mpv"
    "gnome-font-viewer"
    "gnome-shell-extensions"
    "gnome-software"
    "gnome-system-monitor"
    "gnome-tweaks"
    "gnome-weather"
    "totem" # Video player
    "nautilus"
    "baobab" # Disk usage analyzer
    "eog" # Image viewer
    "file-roller"

    "xclip"
    "xorg-xkill"

    "pacman-contrib"
    "reflector"

    # coreutils clones
    "fd" # find clone
    "the_silver_searcher" # command: ag. used to find text contents of files with minimal syntax
    "sd" # sed clone
    "ripgrep"
    "bat" # cat clone

    # Text editors
    "visual-studio-code-bin" # microsoft build of vscode. Needed for live-share
    "intellij-idea-community-edition"
    "imhex"
    "gnome-text-editor"

    # Archival tools and filesystems
    "unzip"
    "zip"
    "p7zip"
    "cdrtools" # Make isos, does a lot more but felt it fit here
    "ntfs-3g"
    "exfatprogs"

    # Browsers
    "firefox-developer-edition"
    "chromium"
    "torbrowser-launcher"

    # Multimedia
    "ffmpeg"
    "yt-dlp"
    "imagemagick"
    # "gifski"

    # Audio
    "wireplumber"
    "pipewire"
    "pipewire-pulse"
    "pipewire-jack"
    "alsa-utils"
    "helvum"
    "pavucontrol"

    # Passwords and OTPs
    "1password"
    "keepassxc"
    "yubioath-desktop"
    "libfido2"
    "solo2-cli-git"

    # Build Tools used frequently by things I use on the AUR
    "cmake"
    "meson"
    "ninja"

    # FONTS!!!
    "cantarell-fonts" # Cantarell
    "inter-font" # Inter
    "gsfonts" # Nimbus Roman
    noto-fonts{,-cjk,-emoji}
    "ttf-unifont" # Unifont
    "ttf-ipa-mona"
    "ttf-ms-fonts"
    "ttf-windows"
    "ttf-ibm-plex"
    "otf-san-francisco-mono"
    "ocr-fonts"
    "ttf-roboto"

    # Extra kernel
    "linux-lts"
    "linux-lts-headers"

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

    # Games
    "steam"
    "prismlauncher-git"

    # Network tools
    "inetutils" # includes drill
    "nmap"
    "bind" # includes dig
    "openbsd-netcat" # open tcp sockets to anything
    "whois"
    "traceroute"

    # Network uhh
    "piavpn-bin"
    "networkmanager-openvpn"
    "nm-connection-editor"
    "wireguard-tools"
    "systemd-resolvconf"

    # Theming
    "adw-gtk3-git" # Make all gtk3 apps look like libadwaita
    "breeze-icons"
    "breeze"
    "qt5ct" # Make QT apps not look awful
    "yaru-sound-theme"

    # Productivity
    "elementary-planner"
    "libreoffice-still"
    "simple-scan"
    "thunderbird"
    "gnome-calendar" # useful to show tasks in the system calendar even if you dont use it itself
    "xournalpp" # pdf markup tool

    # Creating things
    "aseprite" # pixel art editor
    "blender"
    kicad{,-library{,-3d}} # PCB design
    "gimp"
    "inkscape"

    # VM stuff
    "virt-viewer"
    "virt-manager"
    "binfmt-qemu-static"
    "qemu-desktop"
    "qemu-emulators-full"
    "qemu-user-static"
    "dnsmasq" # dns server, needed for vm stuff so in this category
    "edk2-ovmf"
    "edk2-armvirt"
    "swtpm" # virtual TPM

    # Wine
    wine-{gecko,mono,staging}

    # Remote desktop
    "freerdp" # for remmina
    "libvncserver" # for remmina
    "remmina"

    # Smartcard stuff
    "libnfc"
    "libfreefare-git"
    "cardpeek" # read contents of many smartcards
    "mrtdreader" # read contents of passports
    "globalplatformpro" # javacard toolkit
    # proxmark3 deps
    ccache git readline bzip2 arm-none-eabi-gcc arm-none-eabi-newlib qt5-base bluez python

    # SDR stuff
    "rtl-sdr"
    "gqrx"
    "kalibrate-rtl-git"

    # Social networking kinda
    "mumble"
    "signal-desktop"
    "telegram-desktop"

    # Disassembling java stuff
    "jadx" # convert the weird apk java thing to something human readable
    # "recaf" # java bytecode editor
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
