{pkgs ? import <nixpkgs> {}, ...}:
pkgs.stdenv.mkDerivation {
  name = "aoc2023-day08";

  src = ./src;

  buildPhase = ''
    mkdir -p $out/bin
    gcc -c position.c -o position.o -Wall -Wextra -pedantic -std=c11 -I.
    gcc -c crossing.c -o crossing.o -Wall -Wextra -pedantic -std=c11 -I.
    gcc -c map.c -o map.o -Wall -Wextra -pedantic -std=c11 -I.
    gcc -c main.c -o main.o -Wall -Wextra -pedantic -std=c11 -I.
    gcc position.o crossing.o map.o main.o -o $out/bin/aoc2023-day08
  '';
}
