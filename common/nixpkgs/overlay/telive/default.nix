{ lib, stdenv, fetchFromGitHub, libxml2, ncurses, callPackage }:

stdenv.mkDerivation rec {
  pname = "telive";
  version = "04aae1219abdbeb689536ddd293f18562c6e1709";

  src = fetchFromGitHub {
    owner = "adryd325";
    repo = "telive";
    rev = version;
    sha256 = "sha256-ErNqxKxL/4caCHPO1o3eaUMbk9tbnJcrE40EBqwil3g=";
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
