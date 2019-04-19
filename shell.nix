let
  hostPkgs = import <nixpkgs> {};
  nixpkgs = (hostPkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs-channels";
    # SHA for commit on 2019-04-09 on the nixos-19.03 branch
    rev = "5c52b25283a6cccca443ffb7a358de6fe14b4a81";
    sha256 = "0fhbl6bgabhi1sw1lrs64i0hibmmppy1bh256lq8hxy3a2p1haip";
  });
in
  with import nixpkgs {
    overlays = [(self: super:
      {
         python3 = super.python3.override {
           packageOverrides = py-self: py-super: {
             python-language-server = py-super.python-language-server.override {
               providers = [
                 "rope"
                 "pyflakes"
                 "mccabe"
                 "pycodestyle"
                 "pydocstyle"
               ];
             };
           };
         };
      }
    )];
  };

  stdenv.mkDerivation {
    name = "mccrust";
    buildInputs = [
      rustup

      gitAndTools.pre-commit

      pipenv
      python3Packages.black
      python3Packages.epc
      python3Packages.guzzle_sphinx_theme
      python3Packages.importmagic
      python3Packages.isort
      python3Packages.matplotlib
      python3Packages.mypy
      python3Packages.numpy
      python3Packages.pandas
      python3Packages.poetry
      python3Packages.pyls-black
      python3Packages.pyls-isort
      python3Packages.pyls-mypy
      python3Packages.python-language-server
      python3Packages.scipy
      python3Packages.sphinx

      pkgconfig
      openssl
      travis
    ];

    # Set Environment Variables
    RUST_BACKTRACE = 1;
    src = null;
    shellHook = ''
    SOURCE_DATE_EPOCH=$(date +%s)
    '';
  }
