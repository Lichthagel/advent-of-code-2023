{pkgs ? import <nixpkgs> {}, ...}:
pkgs.stdenv.mkDerivation {
  name = "aoc2023-day01";

  src = ./.;

  buildInputs = [];

  buildPhase = ''
    mkdir -p $out/bin
    g++ -o $out/bin/aoc2023-day01 $src/main.cpp
  '';
}
