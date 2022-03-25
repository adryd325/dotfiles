{ lib, stdenv, fetchFromGitHub, libosmocore, talloc, gnutls, callPackage }:

stdenv.mkDerivation rec {
  pname = "osmo-tetra-sq5bpf";
  version = "f730be3e7e426bf4d2b499574f66b26733642c3d";

  src = fetchFromGitHub {
    owner = "sq5bpf";
    repo = "osmo-tetra-sq5bpf";
    rev = version;
    sha256 = "sha256-a5lMrotuRd8rm07TdpEYklCdIICc64HJwB3Kl5PQ4Iw=";
  };

  propagatedBuildInputs = [
    talloc
  ];

  nativeBuildInputs = [
    (callPackage ../libosmocore-sq5bpf { })
  ];

  preBuild = ''
    cd src
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp tetra-rx $out/bin
    mkdir -p $out/lib/$pname
    cp -r demod $out/lib/$pname/demod
  '';

  meta = with lib; {
    description = "Library facilitating decoding and encoding TETRA MAC/PHY layer";
    homepage = "https://github.com/sq5bpf/osmo-tetra-sq5bpf";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
