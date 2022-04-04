#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../../lib/log.sh
source ../../lib/os.sh
[[ "${USER}" = "root" ]] && log error "Do not run as root" && exit 1

../../common/bash/_install.sh
../../common/bash/_install.sh globalInstall

sudo cp -f ./bin/* /usr/local/bin

sudo apt-get update
sudo apt-get upgrade -y
ensureInstalled git direnv rtl-sdr gr-osmosdr gqrx-sdr nodejs npm vlc dnsmasq hostapd netfilter-persistent iptables-persistent lxqt

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
    if ! [[ -e ./phys.py ]]; then
        curl https://raw.githubusercontent.com/sq5bpf/telive/master/gnuradio-companion/receiver_xmlrpc/telive_1ch_gr37_udp_xmlrpc_headless.py -o phys.py
        sed -i "s/self.ppm_corr = ppm_corr = 56/self.ppm_corr = ppm_corr = 34/" phys.py
        sed -i "s/self.freq = freq = 435e6/self.freq = freq = 412962500/" phys.py
    fi
    chmod +x start.sh
    cat > .envrc <<< "use nix"
    mkdir "in"
    mkdir "out"
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
if ! grep "^${lockStr}" /etc/dhcpcd.cong &> /dev/null; then
    log info "Installing dhcpcd config"
    sudo tee -a /etc/dhcpcd.conf &> /dev/null << EOF
${lockStr}
interface wlan0
    static ip_address=192.168.142.1/24
    nohook wpa_supplicant
EOF
fi

lockStr="## adryd-dotfiles-lock (tetra)"
if ! grep "^${lockStr}" /etc/dnsmasq.conf &> /dev/null; then
    log info "Installing dnsmasq config"
    sudo tee -a /etc/dnsmasq.conf &> /dev/null << EOF
${lockStr}
dhcp-range=192.168.142.10,192.168.142.150,255.255.255.0,12h
interface=wlan0 # Listening interface
domain=wlan
address=/gw.wlan/192.168.4.1
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
wpa=3
wpa_passphrase=YesIKnowThisPasswordIsPublic
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
EOF

log info "Enabling hostapd"
sudo systemctl unmask hostapd
sudo systemctl enable hostapd --now

log info "Enabling routing"
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo netfilter-persistent save
sudo tee /etc/sysctl.d/routed-ap.conf > /dev/null <<<  "net.ipv4.ip_forward=1"

log info "Enabling VNC server"
sudo systemctl enable --now vncserver-x11-serviced

log info "Enabling SSH"
sudo systemctl enable --now ssh

log info "Ensuring dvb_usb_rtl28xxu is disabled"
sudo tee /etc/modprobe.d/blacklist-dvb_usb_rtl28xxu.conf > /dev/null <<< "blacklist dvb_usb_rtl28xxu"
