{pkgs ? import <nixpkgs> {}, ...}:
pkgs.stdenv.mkDerivation {
  name = "aoc2023-day03";

  dontUnpack = true;

  propagatedBuildInputs = with pkgs; [
    julia-stable-bin
  ];

  installPhase = ''
    install -Dm755 ${./main.jl} $out/bin/aoc2023-day03
  '';
}
