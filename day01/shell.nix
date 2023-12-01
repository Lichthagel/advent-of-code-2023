{pkgs ? import <nixpkgs> {}, ...}:
pkgs.mkShell {
  name = "aoc2023-day01";

  packages = with pkgs; [
    nim2
  ];
}
