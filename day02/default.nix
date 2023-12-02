{pkgs ? import <nixpkgs> {}, ...}:
pkgs.stdenv.mkDerivation {
  name = "aoc2023-day02";

  src = ./.;

  nativeBuildInputs = [
  ];

  buildInputs = [];

  buildPhase = ''
  '';
}
