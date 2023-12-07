{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  name = "aoc2023-day07";

  packages = with pkgs; [
    deno
  ];
}
