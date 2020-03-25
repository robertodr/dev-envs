let
  sources = import ./nix/sources.nix;
  rustEnv = import ./nix/rustEnv.nix { inherit sources; };
  pythonEnv = import ./nix/pythonEnv.nix { inherit sources; };
  pkgs = import sources.nixpkgs {
    overlays = [ (self: super: {}) ];
  };
in
pkgs.mkShell {
  name = "mclust-rs";
  nativeBuildInputs = [
    pkgs.poetry
    pythonEnv
    rustEnv

    # Build-time Additional Dependencies
    #arrayfire  # GPU library, ultra-heavy to compile
    #pkgconfig
  ];

  # Run-time Additional Dependencies
  buildInputs = [
    # Development tools
    pkgs.gitAndTools.pre-commit
    pkgs.lldb
    pythonEnv.pkgs.ipython
    pythonEnv.pkgs.jupyterlab
  ];

  # Set Environment Variables
  RUST_BACKTRACE = 1;
  RUST_LIB_BACKTRACE = 1;
  SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";
}
