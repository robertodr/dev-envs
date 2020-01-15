with import (builtins.fetchGit {
  name = "nixpkgs-unstable-2020-01-11";
  url = "https://github.com/NixOS/nixpkgs-channels";
  ref = "nixpkgs-unstable";
  # Commit hash for nixpkgs-unstable as of 2020-01-11
  # `git ls-remote https://github.com/nixos/nixpkgs-channels nixpkgs-unstable`
  rev = "7e8454fb856573967a70f61116e15f879f2e3f6a";
}) {
  overlays = [(self: super: {})];
};

let
  srcPoetry = fetchFromGitHub {
    owner = "nix-community";
    repo = "poetry2nix";
    # Commit hash for master as of 2020-01-12
    # `git ls-remote https://github.com/nix-community/poetry2nix.git master`
    rev = "2751a7fa0dd675b95e43a14699c2891143c247ec";
    sha256 = "0s8ywnfdr3w8l3dximqmcd01nw8frxfjw796130px5d8vp3i7ygf";
  };
  srcRust = fetchFromGitHub {
    owner = "mozilla";
    repo = "nixpkgs-mozilla";
    # Commit hash for master as of 2019-10-10
    # `git ls-remote https://github.com/mozilla/nixpkgs-mozilla master`
    rev = "d46240e8755d91bc36c0c38621af72bf5c489e13";
    sha256 = "0icws1cbdscic8s8lx292chvh3fkkbjp571j89lmmha7vl2n71jg";
  };
in
  with import "${srcPoetry.out}/overlay.nix" pkgs pkgs;
  with import "${srcRust.out}/rust-overlay.nix" pkgs pkgs;

let
  pythonEnv = poetry2nix.mkPoetryEnv {
    python = python3;
    poetrylock = ./poetry.lock;
    overrides = [
      poetry2nix.defaultPoetryOverrides
      (self: super: {
         python-language-server = super.python-language-server.override {
           providers = [
             "rope"
             "pyflakes"
             "pycodestyle"
             #"pydocstyle"
           ];
         };
      })
    ];
  };
  rustEnv = ((rustChannelOf {
    date = "2019-08-01";
    channel = "nightly";
  }).rust.override {
    extensions = [
      "rls-preview"
      "rust-analysis"
      "rustfmt-preview"
    ];
  });
in
  mkShell {
    name = "MCCrust";
    nativeBuildInputs = [
      poetry
      pythonEnv
      rustEnv

      # Build-time Additional Dependencies
      #arrayfire  # GPU library, ultra-heavy to compile
      #pkgconfig
    ];

    # Run-time Additional Dependencies
    buildInputs = [
      # Development tools
      gitAndTools.pre-commit
      lldb
      pythonEnv.pkgs.epc
      pythonEnv.pkgs.importmagic
      pythonEnv.pkgs.ipython
      pythonEnv.pkgs.pyls-black
      pythonEnv.pkgs.pyls-isort
      pythonEnv.pkgs.pyls-mypy
      pythonEnv.pkgs.python-language-server
    ];

    # Set Environment Variables
    RUST_BACKTRACE = 1;
    RUST_LIB_BACKTRACE = 1;
    VIRTUAL_ENV = "${pythonEnv.out}";
    #shellHook = ''
    #  # FIXME This is temporarily needed to avoid problems with Cargo
    #  unset SSL_CERT_FILE
    #'';
}
