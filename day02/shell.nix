{pkgs ? import <nixpkgs> {}, ...}:
pkgs.mkShell {
  name = "aoc2023-day02";

  packages = with pkgs; [
    rustc
    cargo
    rustfmt
    clippy
  ];
}
