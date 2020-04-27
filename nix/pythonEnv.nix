{ sources ? import ./sources.nix }:

let
  pkgs =
    import sources.nixpkgs { overlays = [ (import (sources.poetry2nix + "/overlay.nix")) ]; };
  chan = pkgs.poetry2nix.mkPoetryEnv {
    python = pkgs.python3;
    projectDir = ./..;
  };
in
chan
