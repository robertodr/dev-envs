with import (builtins.fetchGit {
  name = "nixos-19.03-2019-06-26";
  url = "https://github.com/NixOS/nixpkgs-channels";
  ref = "nixos-19.03";
  # Commit hash for nixos-19.03 as of 2019-07-18
  # `git ls-remote https://github.com/nixos/nixpkgs-channels nixos-19.03`
  rev = "77295b0bd26555c39a1ba9c1da72dbdb651fd280";
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
  name = "parselglossy";
  buildInputs = [
    gitAndTools.pre-commit
    pipenv
    python3Packages.black
    python3Packages.epc
    python3Packages.guzzle_sphinx_theme
    python3Packages.hypothesis
    python3Packages.importmagic
    python3Packages.isort
    python3Packages.mypy
    python3Packages.pyls-black
    python3Packages.pyls-isort
    python3Packages.pyls-mypy
    python3Packages.pytest
    python3Packages.pytest-flake8
    python3Packages.pytest-mypy
    python3Packages.pytestcov
    python3Packages.python-language-server
    python3Packages.sphinx
    travis
  ];
}
