let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs {
    overlays = [
      (self: super: {
      })
      (import (sources.poetry2nix + "/overlay.nix"))
    ];
  };
  pythonEnv = import ./nix/pythonEnv.nix { inherit pkgs; };
in
pkgs.mkShell {
  name = "diagCCMC";
  nativeBuildInputs = with pkgs; [
    pythonEnv
  ];
}
