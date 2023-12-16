{pkgs ? import <nixpkgs> {}, ...}:
pkgs.stdenvNoCC.mkDerivation {
  name = "aoc2023-day16";

  dontUnpack = true;

  buildInputs = with pkgs; [
    python3
  ];

  installPhase = ''
    install -Dm755 ${./main.py} $out/bin/aoc2023-day16
  '';
}
