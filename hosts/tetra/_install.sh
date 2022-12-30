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
ensureInstalled git direnv rtl-sdr gr-osmosdr gqrx-sdr nodejs npm vlc dnsmasq hostapd netfilter-persistent iptables-persistent lxqt wireguard-tools

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
        sed -i "s/self.ppm_corr = ppm_corr = 56/self.ppm_corr = ppm_corr = 0/" phys.py
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
wpa_passphrase=YesIKnowThisPasswordIsPublic
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
EOF

# log info "Configuring wireguard"
# sudo tee /etc/wireguard/wg0.conf &> /dev/null << EOF
# [Interface]
# PrivateKey =
# Address = 10.0.1.21/32
# DNS = 10.0.0.1

# [Peer]
# PublicKey =
# AllowedIPs = 0.0.0.0/0, ::/0
# Endpoint = changeme:51820
# EOF

log info "Enabling (but not starting) hostapd"
sudo systemctl unmask hostapd
sudo systemctl enable hostapd

log info "Enabling routing"
sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
sudo netfilter-persistent save
sudo tee /etc/sysctl.d/routed-ap.conf > /dev/null <<<  "net.ipv4.ip_forward=1"

log info "Enabling VNC server"
sudo systemctl enable --now vncserver-x11-serviced

log info "Enabling SSH"
sudo systemctl enable --now ssh

log info "Ensuring dvb_usb_rtl28xxu is disabled"
sudo tee /etc/modprobe.d/blacklist-dvb_usb_rtl28xxu.conf > /dev/null <<< "blacklist dvb_usb_rtl28xxu"

log tell "Next steps:"
# log tell " - Setup credentials in /etc/wireguard/wg0.conf to connect to home, and enable wg-quick service"
log tell " - Change password in /etc/hostapd/hostapd.conf"
log tell " - nix-copy-closure from oracle-arm-toronto-1.vm.origin.adryd.com"
log tell " - Start hostapd and see if shit catches fire"
log tell "Using:"
log tell " - Enable VNC for connectivity on a cell phone"
log tell " - Use SSH with X forwarding when connecting from Linux"
log tell " - cd into ~/_/telive or ~/_/tetra-kit and run start.sh"
log tell " - start httpstream by running streamoutput and connecting to http://<ip>:8888/pc.mp3"
