let
  sources = import ./nix/sources.nix;
  pythonEnv = import ./nix/pythonEnv.nix { inherit sources; };
  pkgs = import sources.nixpkgs {
    overlays = [ (self: super: {}) ];
  };
in
pkgs.mkShell {
  name = "LSDALTON";
  nativeBuildInputs = with pkgs; [
    boost
    cmake
    gcc
    gfortran
    mkl
    ninja
    openmpi
    pythonEnv
    zlib
  ];
  buildInputs = with pkgs; [
    gdb
    gitAndTools.pre-commit
    #pythonEnv.pkgs.numpy
    pythonEnv.pkgs.epc
    pythonEnv.pkgs.importmagic
    pythonEnv.pkgs.ipython
    pythonEnv.pkgs.isort
    pythonEnv.pkgs.pyls-isort
    pythonEnv.pkgs.python-language-server
    valgrind
  ];
  hardeningDisable = [ "all" ];
  NINJA_STATUS = "[Built edge %f of %t in %e sec] ";
  MATH_ROOT = "${pkgs.mkl.outPath}";
}
