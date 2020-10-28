#!/bin/bash
# Groups are coppied mostly from fedora

arPackagesGroupsBase=(
    base
    base-devel
    efibootmgr
    git
    grub
    linux
    linux-firmware
    man-db
    man-pages
    nano
    os-prober
    sudo
)

arPackagesGroupsFonts=(
    adobe-source-code-pro-fonts
    cantarell-fonts
    gnu-free-fonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    noto-fonts-extra
    ttf-dejavu
    ttf-droid
    ttf-ibm-plex
    ttf-liberation
    ttf-ms-fonts
    ttf-twemoji
)

arPackagesGroupsGuestUtils=(
    hyperv
    open-vm-tools
    qemu-guest-agent
    spice-vdagent
    virtualbox-guest-utils
)

arPackagesGroupsNetworking=(
    networkmanager
    networkmanager-openvpn
    networkmanager-ssh-git
    networkmanager-strongswan
    networkmanager-wireguard
    openvpn
    dnsmasq
    dhcpcd
)

arPackagesGroupsGnome=(
    dconf
    # gdm
    gdm-prime # patched for optimus-manager, works fine without it
    gedit
    gnome-control-center
    gnome-session
    gnome-settings-daemon
    gnome-shell
    gnome-software
    gnome-terminal
    mutter
    nautilus
    polkit
    yelp
)

arPackagesGroupsGnomeFull=(
    avahi                       # service discovery
    baobab                      # gnome disk-usage analyzer
    cheese                      # gnome camera
    chrome-gnome-shell
    eog                         # gnome image viewer
    epiphany                    # gnome web
    evince                      # gnome document viewer
    file-roller                 # gnome archive viewer
    fprintd
    gnome-backgrounds
    gnome-bluetooth
    gnome-books
    gnome-boxes
    gnome-calculator
    gnome-calendar
    gnome-characters
    gnome-clocks
    gnome-color-manager
    gnome-contacts
    gnome-control-center
    gnome-disk-utility
    gnome-documents
    gnome-font-viewer
    gnome-getting-started-docs
    gnome-keyring
    gnome-logs
    gnome-maps
    gnome-menus
    gnome-photos
    gnome-remote-desktop
    gnome-screenshot
    gnome-shell-extensions
    gnome-system-monitor
    gnome-user-docs
    gnome-user-share
    gnome-tweaks
    gnome-video-effects
    gnome-weather
    grilo-plugins
    gvfs                        # gnome fs mounting
    gvfs-afc
    gvfs-goa
    gvfs-google
    gvfs-gphoto2
    gvfs-mtp
    gvfs-nfs
    gvfs-smb
    orca                        # screen reader
    rygel                       # upnp media
    simple-scan                 # gnome document scanner
    sushi                       # nautilus preview
    totem                       # gnome videos
    tracker                     # search
    tracker3
    tracker3-miners
    tracker-miners
    vino                        # vnc server
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-user-dirs-gtk
    xdg-utils
)

arPackagesGroupsPrinting=(
    cups
    cups-filters
    ghostscript
)

arPackagesGroupsGUIBase=(
    libreoffice-fresh
    firefox
    tor-browser-launcher
    vlc
)

arPackagesGroupsPopsicleHardware=(
    optimus-manager
    throttled
)
