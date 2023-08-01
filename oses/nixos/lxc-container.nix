{ modulesPath, ... }:

{
  imports = [ (modulesPath + "/virtualisation/proxmox-lxc.nix") ];

  networking = {
    domain = "in.adryd.com";
    enableIPv6 = true;
    defaultGateway = "10.142.0.1";
    defaultGateway6 = "2a0f:85c1:212:ffff::1";
    nameservers = [ "10.142.0.1", "2a0f:85c1:212:ffff::1" ];
    dhcpcd.enable = false;
  };
}
