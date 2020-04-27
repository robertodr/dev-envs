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
    pythonEnv
    rustEnv
  ];

  # Run-time Additional Dependencies
  buildInputs = with pkgs; [
    # Development tools
    cargo-expand
    gitAndTools.pre-commit
    lldb
    pythonEnv.pkgs.ipython
    rust-analyzer
  ];

  # Set Environment Variables
  RUST_BACKTRACE = 1;
  SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";
}
