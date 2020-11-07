{ pkgs }:

with pkgs;
poetry2nix.mkPoetryEnv {
  python = python3;
  projectDir = ./..;
}
