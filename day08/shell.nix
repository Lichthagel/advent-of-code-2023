{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  name = "aoc2023-day08";

  packages = with pkgs; [
    gcc
  ];
}
