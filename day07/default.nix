{pkgs ? import <nixpkgs> {}, ...}:
pkgs.stdenvNoCC.mkDerivation {
  name = "aoc2023-day07";

  dontUnpack = true;

  buildInputs = with pkgs; [
    deno
  ];

  buildPhase = ''
    mkdir -p $out/bin
    deno compile --allow-read -o $out/bin/aoc2023-day07 ${./main.ts}
  '';
}
