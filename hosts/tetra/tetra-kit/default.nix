{ pkgs ? import (fetchTarball "http://nixos.org/channels/nixos-21.05/nixexprs.tar.xz") {
  overlays = [
     (import ~/.config/nixpkgs/overlays/adryd-dotfiles/default.nix)
     (import ~/.config/nixpkgs/overlays/adryd-dotfiles/pillow-no-check.nix)
  ]; }
}:

pkgs.mkShell {
  buildInputs = with pkgs; [
    rtl-sdr
    (gnuradio3_7.override {
      extraPackages = with gnuradio3_7Packages; [
        osmosdr
      ];
    })
  ];
}
