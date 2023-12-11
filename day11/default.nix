{pkgs ? import <nixpkgs> {}, ...}:
pkgs.buildGoModule {
  name = "aoc2023-day11";

  src = ./.;

  vendorHash = null;
}
