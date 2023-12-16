{pkgs ? import <nixpkgs> {}, ...}:
pkgs.stdenvNoCC.mkDerivation {
  name = "aoc2023-day14";

  src = ./.;

  nativeBuildInputs = with pkgs; [
    zig
  ];

  buildPhase = ''
    runHook preBuild

    export ZIG_LOCAL_CACHE_DIR=$(pwd)/zig-cache
    export ZIG_GLOBAL_CACHE_DIR=$ZIG_LOCAL_CACHE_DIR

    mkdir -p $out
    zig build -p $out

    runHook postBuild
  '';
}
