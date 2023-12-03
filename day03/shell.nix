{pkgs ? import <nixpkgs> {}, ...}:
pkgs.mkShell {
  name = "aoc2023-day03";

  packages = with pkgs; [
    julia-stable-bin
  ];
}
