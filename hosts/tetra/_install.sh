#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../../lib/log.sh
source ../../lib/os.sh
[[ "${USER}" = "root" ]] && log error "Do not run as root" && exit 1

../../common/bash/_install.sh
../../common/bash/_install.sh globalInstall

sudo apt-get update
sudo apt-get upgrade -y
ensureInstalled git direnv rtl-sdr gr-osmosdr gqrx-sdr nodejs npm vlc dnsmasq hostapd netfilter-persistent iptables-persistent zip unzip

../../common/nix.sh --daemon
../../common/nixpkgs/_install.sh

mkdir -p "${HOME}/_"

# tetra-kit workspace
if ! [[ -d "${HOME}/_/tetra-kit" ]]; then
    log info "Installing tetra-kit workspace"
    cp -r ./tetra-kit "${HOME}/_/tetra-kit"
    (
    cd "${HOME}/_/tetra-kit" || exit $?
    if ! [[ -e ./phys.py ]]; then
        curl https://gitlab.com/larryth/tetra-kit/-/raw/master/phy/pi4dqpsk_rx.grc?inline=false -o phys.grc
    fi

    if ! [[ -d ./tetra-kit-player ]]; then
        git clone https://github.com/sonictruth/tetra-kit-player
        (
            cd tetra-kit-player || exit $?
            npm i
        )
    fi
    chmod +x start.sh
    cat > .envrc <<< "use nix"
    )
fi

# telive workspace
if ! [[ -d "${HOME}/_/telive" ]]; then
    log info "Installing telive workspace"
    cp -r ./telive "${HOME}/_/telive"
    (
    cd "${HOME}/_/telive" || exit
    if ! [[ -e ./tetra.xml ]]; then
        curl https://raw.githubusercontent.com/adryd325/telive/master/tetra.xml -o tetra.xml
    fi
    chmod +x start.sh
    cat > .envrc <<< "use nix"
    )
fi

# sdr-trunk workspace
if ! [[ -d "${HOME}/_/sdr-trunk" ]]; then
    log info "Installing sdr-trunk"
    mkdir "${HOME}/_/sdr-trunk"
    (
    cd "${HOME}/_/sdr-trunk" || exit
    # Latest release at time of writing
    curl https://github.com/DSheirer/sdrtrunk/releases/download/v0.5.0/sdr-trunk-linux-aarch64-v0.5.0.zip -Lo sdrtrunk.zip
    unzip sdrtrunk.zip
    mv -f sdr-trunk-linux-aarch64-v0.5.0/* .
    rm -r sdr-trunk-linux-aarch64-v0.5.0 sdrtrunk.zip
    )
fi


# pm3 build
if ! [[ -d "${HOME}/_/proxmark3" ]]; then
    log info "Installing proxmark3"
    ensureInstalled git ca-certificates build-essential pkg-config libreadline-dev gcc-arm-none-eabi libnewlib-dev qtbase5-dev libbz2-dev libbluetooth-dev libpython3-dev libssl-dev
    mkdir "${HOME}/_/proxmark3"
    (
    cd "${HOME}/_/proxmark3" || exit
    git clone https://github.com/RfidResearchGroup/proxmark3 .
    # Sync version between popsicle and tetra
    git checkout 73a80fb07db22f3cba56f8e3ef7c205f1a378441
    sed -i "s/PLATFORM=PM3RDV4/PLATFORM=PM3GENERIC/" Makefile.platform
    make accessrights
    make clean && make -j
    sudo make install
    )
fi

if ! [[ -e "${HOME}/.config/nixpkgs/config.nix" ]]; then
    log info "Installing nixpkgs config"
    mkdir -p "${HOME}/.config/nixpkgs"
    cat > "${HOME}/.config/nixpkgs/config.nix" << EOF
{
    permittedInsecurePackages = [
    "python2.7-Pillow-6.2.2"
    ];
}
EOF
fi

lockStr="## adryd-dotfiles-lock (tetra)"
if ! grep "^${lockStr}" /etc/dhcpcd.conf &> /dev/null; then
    log info "Installing dhcpcd config"
    sudo tee -a /etc/dhcpcd.conf &> /dev/null << EOF
${lockStr}
interface eth0
    static ip_address=10.0.0.21/24
    static routers=10.0.0.1
    static domain_name_servers=10.0.0.1 8.8.8.8

interface wlan0
    static ip_address=10.142.21.1/24
    nohook wpa_supplicant
EOF
fi

if ! grep "^${lockStr}" /etc/dnsmasq.conf &> /dev/null; then
    log info "Installing dnsmasq config"
    sudo tee -a /etc/dnsmasq.conf &> /dev/null << EOF
${lockStr}
dhcp-range=10.142.21.10,10.142.21.50,255.255.255.0,12h
interface=wlan0 # Listening interface
domain=wlan
address=/gw.wlan/10.142.21.1
EOF
fi

log info "Installing hostapd config"
sudo tee /etc/hostapd/hostapd.conf &> /dev/null << EOF
country_code=CA
interface=wlan0
driver=nl80211
ssid=TETRA
channel=7
hw_mode=g
wme_enabled=1
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=412962500
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
EOF
# Yes the password is public, if you somehow happen to run into me in public you deserve to get to listen to the audio stream...

log info "Enabling (but not starting) hostapd"
sudo systemctl unmask hostapd
sudo systemctl enable hostapd

log info "Enabling routing"
sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
sudo netfilter-persistent save
sudo tee /etc/sysctl.d/routed-ap.conf > /dev/null <<< "net.ipv4.ip_forward=1"

log info "Enabling VNC server"
sudo systemctl enable --now vncserver-x11-serviced

log info "Enabling SSH"
sudo systemctl enable --now ssh

log info "Ensuring dvb_usb_rtl28xxu is disabled"
sudo tee /etc/modprobe.d/blacklist-dvb_usb_rtl28xxu.conf > /dev/null <<< "blacklist dvb_usb_rtl28xxu"

log info "Installing tetra-autostart script"
sudo cp -f ./tetra-autostart.desktop /etc/xdg/autostart/tetra-autostart.desktop

log tell "Next steps:"
log tell " - nix-copy-closure from oracle-arm-toronto-1.vm.origin.adryd.com"
log tell " - Start hostapd"
log tell "Using:"
log tell " - Enable VNC for connectivity on a cell phone"
log tell " - Use SSH with X forwarding when connecting from Linux"
log tell " - Run telive or sdrtrunk from a terminal to get started"


## TODO
## connman unblock after apt update
## use vncauth instead of whatever realvnc uses
