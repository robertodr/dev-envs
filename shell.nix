with import (builtins.fetchGit {
  name = "nixos-19.03-2019-07-07";
  url = "https://github.com/NixOS/nixpkgs-channels";
  ref = "nixos-19.03";
  # Commit hash for nixos-19.03 as of 2019-07-07
  # `git ls-remote https://github.com/nixos/nixpkgs-channels nixos-19.03`
  rev = "799a080ba1b1f969e737279cb6e7758a30e28754";
}) {
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
