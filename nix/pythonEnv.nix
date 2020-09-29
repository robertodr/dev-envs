{ pkgs }:
let
  chan = pkgs.poetry2nix.mkPoetryEnv {
    python = pkgs.python37;
    projectDir = ./..;
  };
in
chan
