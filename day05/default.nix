{pkgs ? import <nixpkgs> {}, ...}:
pkgs.stdenvNoCC.mkDerivation {
  name = "aoc2023-day05";

  dontUnpack = true;

  buildInputs = with pkgs; [
    swiProlog
  ];

  installPhase = ''
    install -Dm755 ${./main.pl} $out/bin/aoc2023-day05
  '';
}
