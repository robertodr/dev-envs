let
  outer = import <nixpkgs> {};
in
  {
    pkgs ? import (outer.fetchFromGitHub {
      # Obtained on 2020-01-20 with `nix-prefetch-github nixos nixpkgs-channels --nix --rev nixpkgs-unstable`
      owner = "nixos";
      repo = "nixpkgs-channels";
      rev = "8da81465c19fca393a3b17004c743e4d82a98e4f";
      sha256 = "1f3s27nrssfk413pszjhbs70wpap43bbjx2pf4zq5x2c1kd72l6y";
    }) {
      overlays = [(self: super: {})];
    }
  }:

with pkgs;
let
  # Obtained on 2020-01-21 with `nix-prefetch-github nix-community poetry2nix --nix`
  srcPoetry = fetchFromGitHub {
    owner = "nix-community";
    repo = "poetry2nix";
    rev = "f1af96e2c5f4abcd1bbebbc370390edc0acfd84f";
    sha256 = "0phvbj7dg8pf82qa2519hy8lh0wpjhi5c7d46iv22pwhhhiiynkn";
  };
  # Obtained on 2020-01-16 with `nix-prefetch-github mozilla nixpkgs-mozilla --nix`
  srcRust = fetchFromGitHub {
    owner = "mozilla";
    repo = "nixpkgs-mozilla";
    rev = "5300241b41243cb8962fad284f0004afad187dad";
    sha256 = "1h3g3817anicwa9705npssvkwhi876zijyyvv4c86qiklrkn5j9w";
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
    SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";
    shellHook = ''
      local venv=$(poetry env info -p)

      if [[ -z $venv || ! -d $venv ]]; then
        poetry env use ${pythonEnv.out}/bin/python &>> /dev/null
        venv=$(poetry env info -p)
      fi

      export VIRTUAL_ENV="$venv"
    '';
}
