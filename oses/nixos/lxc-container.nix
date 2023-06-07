{ modulesPath, ... }:

{
  imports = [ (modulesPath + "/virtualisation/proxmox-lxc.nix") ];

  networking = {
    domain = "in.adryd.com";
    enableIPv6 = false;
    defaultGateway = "10.142.0.1";
    nameservers = [ "10.142.0.1" ];
    dhcpcd.enable = false;
  };
}
