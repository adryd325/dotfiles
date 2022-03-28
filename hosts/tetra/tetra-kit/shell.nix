{ pkgs ? import (fetchTarball "http://nixos.org/channels/nixos-21.05/nixexprs.tar.xz") { overlays = [ (import ~/.config/nixpkgs/overlays/adryd-dotfiles/default.nix) ]; }
}:

pkgs.mkShell {
  buildInputs = with pkgs; [
    rtl-sdr
    (python27Packages.pillow.overrideAttrs (old: rec{
      doCheck = false;
      doInstallCheck = false;
    }))
    (gnuradio3_7.override {
      extraPackages = with gnuradio3_7Packages; [
        osmosdr
      ];
    })
  ];
}
