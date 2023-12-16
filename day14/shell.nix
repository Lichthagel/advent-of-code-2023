{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  name = "aoc2023-day14";

  packages = with pkgs; [
    zig
    zls
  ];
}
