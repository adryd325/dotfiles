{ lib, stdenv, fetchzip, fetchpatch, rename }:

stdenv.mkDerivation rec {
  pname = "etsi-tetra-codec-sq5bpf";
  version = "01.03.01_60";

  src = fetchzip {
    url = "https://www.etsi.org/deliver/etsi_en/300300_300399/30039502/01.03.01_60/en_30039502v010301p0.zip";
    hash = "sha256-CQ3zJsePC/AGyYwBcZmEfMyCA29r/sRbZ5/sjW6GhjA=";
    stripRoot = false;
  };

  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/sq5bpf/install-tetra-codec/master/codec.diff";
      hash = "sha256-HM5KGt34GC70djDzxMrXQsybICY+IBKLKxOd3HJvmnA=";
      sha256 = "02c8a585086f6739c4ce1ff35ce5cd99d2f28b800234a9ed9f684507e7417274";
    })
  ];

  nativeBuildInputs = [ rename ];

  buildPhase = ''
    rename 'y/A-Z/a-z/' $out/*
    rename 'y/A-Z/a-z/' $out/**/*
    cd c-code
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp sdecoder scoder cdecoder ccoder $out/bin
  '';

  meta = with lib; {
    description = "Tetra codec";
    homepage = "https://github.com/sq5bpf/install-tetra-codec";
    platforms = platforms.linux;
  };
}
