let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs {
    overlays = [
      (self: super: {
        blas = super.blas.override {
          blasProvider = self.mkl;
        };
        lapack = super.lapack.override {
          lapackProvider = self.mkl;
        };
      })
      (import (sources.poetry2nix + "/overlay.nix"))
    ];
  };
  pythonEnv = import ./nix/pythonEnv.nix { inherit pkgs; };
in
pkgs.mkShell {
  name = "VeloxChem";
  nativeBuildInputs = with pkgs; [
    clang-analyzer
    clang-tools
    cmake
    gcc
    gtest
    mkl
    ninja
    openmpi
    #pybind11
    pythonEnv
    #zlib
  ];
  buildInputs = with pkgs; [
    gdb
    valgrind
  ];
  hardeningDisable = [ "all" ];
  NINJA_STATUS = "[Built edge %f of %t in %e sec] ";
}
