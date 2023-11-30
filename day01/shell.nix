{pkgs ? import <nixpkgs> {}, ...}:
pkgs.mkShell {
  name = "aoc-2023-day-01";

  packages = [];
}
