{ sources ? import ./sources.nix }:

let
  pkgs =
    import sources.nixpkgs { overlays = [ (import (sources.poetry2nix + "/overlay.nix")) ]; };
  chan = pkgs.poetry2nix.mkPoetryEnv {
    python = pkgs.python3;
    poetrylock = ../poetry.lock;
    overrides = [
      pkgs.poetry2nix.defaultPoetryOverrides
      (
        self: super: {
          numpy = super.numpy.override {
            blas = pkgs.mkl;
          };
        }
      )
    ];
  };
in
chan
