with import (builtins.fetchGit {
  name = "nixos-19.03-2019-08-20";
  url = "https://github.com/NixOS/nixpkgs-channels";
  ref = "nixos-19.03";
  # Commit hash for nixos-19.03 as of 2019-08-20
  # `git ls-remote https://github.com/nixos/nixpkgs-channels nixos-19.03`
  rev = "5e5a51f7868df98d6db4331bb6cf149040ce474a";
}) {
  overlays = [
    (import ~/.config/nixpkgs/overlays/default.nix)
    (self: super: {
       python3 = super.python3.override {
         packageOverrides = py-self: py-super: {
           python-language-server = py-super.python-language-server.override {
             providers = [
               "rope"
               "pyflakes"
               "mccabe"
               "pycodestyle"
               "pydocstyle"
               "yapf"
             ];
           };
         };
       };
    })
  ];
};

stdenv.mkDerivation {
  name = "Psi4";
  nativeBuildInputs = [
    boost
    bundler
    clang
    clang-analyzer
    clang-tools
    cmake
    gau2grid
    gdb
    gfortran
    libint
    libxc
    lldb
    mkl
    ninja-kitware
    pybind11
    valgrind
    zlib
  ];
  buildInputs = [
    pipenv
    python3
    python3.pkgs.epc
    python3.pkgs.importmagic
    python3.pkgs.isort
    python3.pkgs.jedi
    python3.pkgs.mypy
    python3.pkgs.pyls-isort
    python3.pkgs.pyls-mypy
    python3.pkgs.python-language-server
    travis
  ];
  hardeningDisable = [ "all" ];
  src = null;
  shellHook = ''
    SOURCE_DATE_EPOCH=$(date +%s) # required for python wheels

    # FIXME This is temporarily needed to avoid problems with Cargo
    unset SSL_CERT_FILE

    local venv=$(pipenv --bare --venv &>> /dev/null)

    if [[ -z $venv || ! -d $venv ]]; then
      pipenv install --dev &>> /dev/null
    fi

    export VIRTUAL_ENV=$(pipenv --venv)
    export PIPENV_ACTIVE=1
    export PYTHONPATH="$VIRTUAL_ENV/${python3.sitePackages}:$PYTHONPATH"
    export PATH="$VIRTUAL_ENV/bin:$PATH"
  '';
}
