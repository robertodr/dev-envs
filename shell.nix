let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs {
    config = {
      allowUnfree = true;
    };
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
  mach-nix = import sources.mach-nix {
    pkgs = pkgs;
    python = "python38";
  };
  pythonEnv = mach-nix.mkPython rec {
    requirements = builtins.readFile ./requirements.txt;
  };
in
pkgs.mkShell {
  name = "VeloxChem";
  nativeBuildInputs = with pkgs; [
    clang-analyzer
    clang-tools
    clang_11
    cmake
    gcc
    gtest
    llvmPackages_11.openmp
    mkl
    ninja
    openmpi
    pythonEnv
    pythonEnv.pkgs.isort
    pythonEnv.pkgs.jupyterlab
    pythonEnv.pkgs.pytest
    pythonEnv.pkgs.requests
    pythonEnv.pkgs.yapf
  ];
  buildInputs = with pkgs; [
    lldb
    valgrind
  ];
  hardeningDisable = [ "all" ];
  NINJA_STATUS = "[Built edge %f of %t in %e sec] ";
  KMP_DUPLICATE_LIB_OK = "TRUE";
}
