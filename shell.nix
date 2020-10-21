let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs {
    overlays = [
    ];
  };
in
pkgs.mkShell {
  name = "MRCPP";
  nativeBuildInputs = with pkgs; [
    clang-analyzer
    clang-tools
    cmake
    eigen
    gcc
    ninja
    openmpi
  ];
  buildInputs = with pkgs; [
    gdb
    python3
    python3.pkgs.pyyaml
    valgrind
  ];
  hardeningDisable = [ "all" ];
  NINJA_STATUS = "[Built edge %f of %t in %e sec] ";
}
