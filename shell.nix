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

      pipenv

      # Python dev-packages
      gitAndTools.pre-commit
      python3Packages.black
      python3Packages.epc
      python3Packages.guzzle_sphinx_theme
      python3Packages.importmagic
      python3Packages.isort
      python3Packages.jedi
      python3Packages.mypy
      python3Packages.pyls-black
      python3Packages.pyls-isort
      python3Packages.pyls-mypy
      python3Packages.pytest
      python3Packages.python-language-server
      python3Packages.sphinx

      # Python packages
      # NOTE some additional packages are installed by hand in .envrc
      python3Packages.cython  # Needed to get randomgen
      python3Packages.matplotlib
      python3Packages.numpy
      python3Packages.pandas

      lldb
      openssl
      pkgconfig
      travis
    ];

    # Set Environment Variables
    RUST_BACKTRACE = 1;
    src = null;
    shellHook = ''
    SOURCE_DATE_EPOCH=$(date +%s)
    '';
  }
