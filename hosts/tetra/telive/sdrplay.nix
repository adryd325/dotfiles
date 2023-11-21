{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-23.05.tar.gz") {
  overlays = [
     (import ~/.config/nixpkgs/overlays/adryd-dotfiles/default.nix)
     (import ~/.config/nixpkgs/overlays/adryd-dotfiles/pillow-no-check.nix)
  ]; }
}:

pkgs.mkShell {
  buildInputs = with pkgs; [
    sdrplay
    gr-sdrplay3
    swig
    python310
    python310Packages.numpy
    (gnuradio3_9.override {
      extraPackages = with gnuradio3_9Packages; [
        gr-sdrplay3
      ];
    })
  ];
}
