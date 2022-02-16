{ config, pkgs, ... }:

{
  imports = [ /opt/adryd-dotfiles/oses/nixos/lxc-container.nix ];

  networking = {
    hostName = "thelounge";
    interfaces.eth0.ipv4.addresses = [{
      address = "10.0.0.120";
      prefixLength = 24;
    }];
  };

  services.thelounge.enable = true;
  networking.firewall.allowedTCPPorts = [ 9000 ];
}
