{
  description = "Advent of Code 2023";

  outputs = {
    self,
    nixpkgs,
    flake-parts,
    flake-utils,
    ...
  } @ inputs: let
    days = [
      "day01"
      "day02"
      "day03"
      "day04"
      "day05"
      "day05-rs"
      "day06"
      "day07"
      "day08"
      "day09"
      "day10"
      "day11"
      "day12"
    ];
  in
    flake-parts.lib.mkFlake {inherit inputs;}
    {
      systems = flake-utils.lib.defaultSystems;

      perSystem = {
        config,
        lib,
        pkgs,
        system,
        ...
      }: {
        packages = lib.genAttrs days (day: import ./${day}/default.nix {inherit pkgs;});

        devShells = lib.genAttrs days (day: import ./${day}/shell.nix {inherit pkgs;});
      };
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    flake-utils.url = "github:numtide/flake-utils";
  };
}
