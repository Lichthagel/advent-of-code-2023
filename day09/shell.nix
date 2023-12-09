{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  name = "aoc2023-day09";

  packages = with pkgs; [
    erlang
  ];
}
