let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs {
    overlays = [
      (self: super: {
        lapack = super.lapack.override {
          lapackProvider = self.mkl;
        };
        blas = super.blas.override {
          blasProvider = self.mkl;
        };
      })
      (import ~/.config/nixpkgs/overlays/default.nix)
      (import (sources.poetry2nix + "/overlay.nix"))
    ];
  };
  pythonEnv = import ./nix/pythonEnv.nix { inherit pkgs; };
in
pkgs.mkShell {
  name = "MRDev";
  nativeBuildInputs = with pkgs; [
    cmake
    eigen
    gcc
    ninja
    nlohmann_json
    openmpi
    pythonEnv
  ];

  # Run-time Additional Dependencies
  buildInputs = with pkgs; [
    # Development tools
    bundler
    clang-analyzer
    clang-tools
    doxygen_gui
    graphviz
    lcov
    lldb
    travis
    valgrind
  ];

  hardeningDisable = [ "all" ];
  NINJA_STATUS = "[Built edge %f of %t in %e sec] ";
}
