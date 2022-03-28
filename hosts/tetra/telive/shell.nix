{ pkgs ? import (fetchTarball "http://nixos.org/channels/nixos-21.05/nixexprs.tar.xz") { overlays = [ (import ~/.config/nixpkgs/overlays/adryd-dotfiles/default.nix) ]; }
}:

pkgs.mkShell {
  buildInputs = with pkgs; [
    rtl-sdr
    libxml2
    ncurses
    python27
    python27Packages.numpy
    (python27Packages.pillow.overrideAttrs (old: rec{
      doCheck = false;
      doInstallCheck = false;
    }))
    gnuradio3_7Packages.osmosdr
    xterm
    terminus_font
    socat
    gqrx
    etsi-tetra-codec-sq5bpf
    libosmocore-sq5bpf
    osmo-tetra-sq5bpf
    telive
    (gnuradio3_7.override {
      extraPackages = with gnuradio3_7Packages; [
        osmosdr
      ];
    })
  ];
  shellHook = ''
    export TETRA_OUTDIR="$(pwd)/in"
    export TETRA_LOGFILE="$(pwd)/telive.log"
    #export TETRA_PORT=7379 # default
    export TETRA_KEYS=VVVVq # verbose, start scanning
    #export TETRA_SSI_FILTER=
    #export TETRA_KML_FILE=$(pwd)/tetra1.kml
    #export TETRA_KML_INTERVAL=30
    export TETRA_SSI_DESCRIPTIONS=ssi_descriptions # default
    export TETRA_XMLFILE=tetra.xml
    export TETRA_LOCK_FILE=telive_lock # default
    export TETRA_GR_XMLRPC_URL=http://127.0.0.1:42000/ # default
    #export TETRA_SCAN_LIST="412.0-413.2/12.5;422.0-424.0/12.5" # TTC Slow
    export TETRA_SCAN_LIST="412.0375-412.0376/1;412.0625-412.0626/1;412.1125-412.1126/1;412.2125-412.2126/1;412.6125-412.6126/1;412.9625-412.9626/1;413.1875-413.1876/1;422.6625-422.6626/1;422.6875-422.6876/1;422.8-422.8001/1;423.2625-423.2626/1;423.2875-423.2876/1;423.3125-423.3126/1;423.3375-423.3376/1;423.3625-423.3626/1;423.4375-423.4376/1;423.4625-423.4626/1;423.5375-423.5376/1;423.6125-423.6126/1;423.7375-423.7376/1" # TTC Fast
    #export TETRA_FREQLOGFILE=telive_frequency.log # default
    export TETRA_FREQUENCY_REPORT_FILE=telive_frequency_report.txt # default
    #export TETRA_RX_GAIN=30
    export TETRA_RX_PPM=34
    export TETRA_RX_PPM_AUTOCORRECT=1 # default
    export TETRA_RX_BASEBAND_AUTOCORRECT=1 # default
    export TETRA_RX_BASEBAND=412.9625
    export TETRA_AUTO_TUNE=1
    #export TETRA_RX_TUNE="412.9625;" # closest to home 412.9625 423.6125 423.3125 423.7375 412.0375
    #export TETRA_REC_TIMEOUT=30 # default
    #export TETRA_SSI_TIMEOUT=60 # default
    #export TETRA_IDX_TIMEOUT=8 # default
    #export TETRA_CURPLAYING_TIMEOUT=5 # default
    #export TETRA_FREQ_TIMEOUT=600 # default
    export TETRA_SCAN_TIMEOUT_SIGNAL=50
    export TETRA_SCAN_TIMEOUT_BURST=600
    export TETRA_SCAN_TIMEOUT_SYSINFO=4000
  '';
}
