{pkgs ? import <nixpkgs> {}, ...}: let
  cargoToml = builtins.fromTOML (builtins.readFile ./Cargo.toml);
in
  pkgs.rustPlatform.buildRustPackage {
    inherit (cargoToml.package) name version;
    src = ./.;
    cargoLock.lockFile = ./Cargo.lock;
  }
