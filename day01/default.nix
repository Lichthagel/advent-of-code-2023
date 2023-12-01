{pkgs ? import <nixpkgs> {}, ...}:
pkgs.stdenv.mkDerivation {
  name = "aoc2023-day01";

  src = ./.;

  nativeBuildInputs = with pkgs; [
    nim2
  ];

  buildInputs = [];

  buildPhase = ''
    mkdir -p $out/bin
    nim c --nimcache:$TMPDIR -o:$out/bin/aoc2023-day01 $src/main.nim
  '';
}
