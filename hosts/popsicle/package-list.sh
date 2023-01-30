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
    "gnome-browser-connector"
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
    "gamemode"
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
    "insect"
    "intel-gpu-tools"
    "screen"
    "power-profiles-daemon"


    # Uncategorized gui tools
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
    "gnome-tweaks"
    "gnome-weather"
    "totem" # Video player
    "nautilus"
    "baobab" # Disk usage analyzer
    "eog" # Image viewer
    "file-roller"
    "jetbrains-toolbox"
    "obsidian"
    "rpi-imager-bin"
    "cheese"

    "xclip"
    "xorg-xkill"

    "pacman-contrib"
    "reflector"

    # coreutils clones
    "the_silver_searcher" # command: ag. used to find text contents of files with minimal syntax
    "bat" # cat clone

    # Text editors
    "visual-studio-code-bin" # microsoft build of vscode. Needed for live-share
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
    "gifski"

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
    "rtl8812au-dkms-git" # USB wifi dongle for hotspot

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
    "nm-connection-editor"
    "wireguard-tools"
    "systemd-resolvconf"

    # Theming
    "adw-gtk3-git" # Make all gtk3 apps look like libadwaita
    "qt5ct" # Make QT apps not look awful

    # Productivity
    "simple-scan"
    "thunderbird"
    "gnome-calendar" # useful to show tasks in the system calendar even if you dont use it itself
    "xournalpp" # pdf markup tool

    # Creating things
    "aseprite" # pixel art editor
    #"blender"
    #kicad{,-library{,-3d}} # PCB design
    "gimp"
    "inkscape"

    # VM stuff
    "virt-viewer"
    "virt-manager"
    "qemu-desktop"
    "qemu-emulators-full"
    "qemu-user-static"
    "qemu-user-static-binfmt"
    "dnsmasq" # dns server, needed for vm stuff so in this category
    "edk2-ovmf"
    "edk2-aarch64"
    "swtpm" # virtual TPM

    # Wine
    wine-{gecko,mono,staging}

    # Remote desktop
    "freerdp" # for remmina
    "libvncserver" # for remmina
    "remmina"

    # Smartcard stuff
    #"libnfc"
    #"libfreefare-git"
    #"cardpeek" # read contents of many smartcards
    #"mrtdreader" # read contents of passports
    # "globalplatformpro" # javacard toolkit
    # proxmark3 deps
    ccache git readline bzip2 arm-none-eabi-gcc arm-none-eabi-newlib qt5-base bluez python

    # SDR stuff
    "rtl-sdr"
    #"gqrx"
    #"kalibrate-rtl-git"
    #"x11vnc" # For controlling laptop from phone
    #"vlc" # provides an easy way of broadcasting audio via http
    "gqrx"

    # Radio stuff
    "qdmr"
    "spi-ch341-usb-dkms"
    "chirp-hg"

    # Social networking kinda
    #"mumble"
    "signal-desktop"
    "telegram-desktop"

    # Disassembling java stuff
    #"jadx" # convert the weird apk java thing to something human readable
    #"recaf" # java bytecode editor

    # Watch stuff
    "itd-bin"
)

flatpaks=(
    #"net.blockbench.Blockbench"
    "com.github.tchx84.Flatseal"
    "re.sonny.Junction"
    "com.belmoussaoui.Obfuscate"
    #"com.parsecgaming.parsec"
    #"uk.co.powdertoy.tpt"
    "org.gnome.SoundRecorder"
)

export packages
export flatpaks
export flatpaksGnomeNightly
