{pkgs ? import <nixpkgs> {}, ...}:
pkgs.stdenvNoCC.mkDerivation {
  name = "aoc2023-day09";

  dontUnpack = true;

  buildInputs = with pkgs; [
    erlang
  ];

  installPhase = ''
    install -Dm755 ${./main.escript} $out/bin/aoc2023-day09
  '';
}
