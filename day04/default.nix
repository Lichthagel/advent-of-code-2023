{pkgs ? import <nixpkgs> {}, ...}:
pkgs.stdenvNoCC.mkDerivation {
  name = "aoc2023-day04";

  dontUnpack = true;

  buildInputs = with pkgs; [
    ruby
  ];

  installPhase = ''
    install -Dm755 ${./main.rb} $out/bin/aoc2023-day04
  '';
}
