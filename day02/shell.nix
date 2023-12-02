{pkgs ? import <nixpkgs> {}, ...}:
pkgs.mkShell {
  name = "aoc2023-day02";

  packages = with pkgs; [
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
  ];

  RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
}
