{
  imports = [ <nixpkgs/nixos/modules/virtualisation/lxc-container.nix> ];

  systemd.suppressedSystemUnits = [ "sys-kernel-debug.mount" ];

  networking = {
    domain = "in.adryd.com";
    enableIPv6 = false;
    defaultGateway = "10.142.0.1";
    nameservers = [ "10.142.0.1" ];
    dhcpcd.enable = false;
  };
}
