{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  name = "aoc2023-day06";

  packages = with pkgs; [
    lua
  ];
}
