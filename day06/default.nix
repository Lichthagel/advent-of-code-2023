{pkgs ? import <nixpkgs> {}, ...}:
pkgs.stdenvNoCC.mkDerivation {
  name = "aoc2023-day06";

  dontUnpack = true;

  buildInputs = with pkgs; [
    lua
  ];

  installPhase = ''
    install -Dm755 ${./main.lua} $out/bin/aoc2023-day06
  '';
}
