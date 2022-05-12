{ config, pkgs, ... }:

{
  imports = [ <nixpkgs/nixos/modules/virtualisation/lxc-container.nix> /opt/adryd-dotfiles/oses/nixos/common.nix ];
  systemd.suppressedSystemUnits = [ "sys-kernel-debug.mount" ];

  networking = {
    domain = "in.adryd.com";
    defaultGateway = "10.0.0.1";
    nameservers = [ "10.0.0.1" ];
    dhcpcd.enable = false;
    enableIPv6 = true;
    hostName = "web";
    interfaces.eth0.ipv4.addresses = [{
      address = "10.0.0.102";
      prefixLength = 24;
    }];

    firewall = {
      allowedTCPPorts = [ 80 443 8080 8443 ];
      allowedUDPPorts = [ 443 51820 ];
    };

    wireguard.interfaces = {
      wg0 = {
        ips = [ "10.142.2.2/24" ];
        listenPort = 51820;
        privateKeyFile = "/etc/wireguard/privkey.key";
        peers = [
          {
            publicKey = "lSYSha0WUz4D9WoiXIfMnEAZU4uPvkPRgE5kZab4Lw0=";
            # Only route 10.142.2.0/24 over the vpn
            # Route all IPv6
            allowedIPs = [ "10.142.2.0/24" "::/0" ];
            # hetzner-nbg1-dc3.vm.origin.adryd.com
            endpoint = "116.203.183.195:51820";
            persistentKeepalive = 25;
          }
        ];
      };
    };

  };

  services.nginx.enable = true;
  services.nginx.virtualHosts."webnix.in.adryd.com" = {
    root = "/var/www/test";
  };
}
