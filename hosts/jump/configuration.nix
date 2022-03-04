{ config, lib ,pkgs, ... }:

webhookUrl = import ./webhook.nix;
let
  notify = with pkgs; writeScriptBin "login-email-notification" ''
    #! ${runtimeShell} -e
    WEBHOOK="${webhookUrl}"
    PUBKEY=''$(tail -10 /var/log/auth.log | grep "Accepted publickey for ''${PAM_USER} from ''${PAM_RHOST}" | tail -1 | sed "s/Accepted publickey for [^ ]* from [^ ]* //g" | tail -1)
    MESSAGE="Successful login for ''${PAM_USER} from ''${PAM_RHOST} ''$PUBKEY"

    if [[ ''${PAM_TYPE} = "open_session" ]]; then
      curl -X POST -k -H 'Content-Type: application/json' -d "{\"content\":\"$MESSAGE\"}" $WEBHOOK &
    fi

    exit 0
  '';
in
{
  imports = [ /opt/adryd-dotfiles/oses/nixos/lxc-container.nix ./users.nix ];

  security.pam.services.sshd.externalCommand = {
    type = "session";
    control = "required";
    command = "${notify}/bin/login-email-notification";
  };

  networking = {
    hostName = "jump";
    interfaces.eth0.ipv4.addresses = [{
      address = "10.0.0.101";
      prefixLength = 24;
    }];
    firewall.allowedTCPPorts = [ 22 2222 ];
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    ports = [ 22 2222 ];
    passwordAuthentication = false;
    permitRootLogin = "no";
    gatewayPorts = "no";
    logLevel = "VERBOSE";
    extraConfig = "
GSSAPIAuthentication no
PermitEmptyPasswords no
AuthenticationMethods publickey
PermitTTY no
PermitTunnel no
Match Port 22
  Banner /opt/adryd-dotfiles/hosts/jump/ssh_banner
Match User adryd
  PermitTunnel yes
  GatewayPorts yes
";
  };

  services.fail2ban.enable = true;
}
