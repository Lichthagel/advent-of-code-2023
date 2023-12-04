{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  name = "aoc2023-day04";

  packages = with pkgs; [
    ruby
    ruby-lsp
    rubyPackages.sorbet-runtime
  ];
}
