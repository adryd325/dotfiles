{ lib, stdenv, fetchFromGitHub, libxml2, ncurses, callPackage }:

stdenv.mkDerivation rec {
  pname = "osmo-tetra-sq5bpf";
  version = "44304af1d516275690b41a77031e961412ece95e";

  src = fetchFromGitHub {
    owner = "sq5bpf";
    repo = "telive";
    rev = version;
    sha256 = "sha256-9X6dZFS9QMVr0t0PVjgCTwuxe1KvwsK3LyLC5oLWT8I=";
  };

  nativeBuildInputs = [
    libxml2
    ncurses
    (callPackage ../libosmocore-sq5bpf { })
    (callPackage ../osmo-tetra-sq5bpf { })
  ];

  postBuild = ''
    sed -i "s:/tetra/bin/::g" bin/tplay
    sed -i "s:/TDIR=/tetra/in:in:g" bin/tplay
    sed -i "s:/ODIR=/tetra/out:out:g" bin/tplay
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp telive bin/* $out/bin
  '';

  meta = with lib; {
    description = "Tetra live monitor";
    homepage = "https://github.com/sq5bpf/telive";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
