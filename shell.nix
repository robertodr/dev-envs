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
    ];
  };
in
pkgs.mkShell {
  name = "VAMPyR";
  nativeBuildInputs = with pkgs; [
    black
    clang-analyzer
    clang-tools
    cmake
    eigen
    gcc
    ninja
  ];
  buildInputs = with pkgs; [
    gdb
    python3
    python3.pkgs.numpy
    python3.pkgs.pybind11
    python3.pkgs.pytest
    python3.pkgs.pyyaml
    valgrind
  ];
  hardeningDisable = [ "all" ];
  NINJA_STATUS = "[Built edge %f of %t in %e sec] ";
}
