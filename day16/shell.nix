{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  name = "aoc2023-day16";

  packages = with pkgs; [
    python3
  ];
}
