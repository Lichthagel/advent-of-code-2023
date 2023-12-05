{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  name = "aoc2023-day05";

  packages = with pkgs; [
    swiProlog
  ];
}
