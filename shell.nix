with import (builtins.fetchGit {
  name = "nixos-19.09-2019-10-10";
  url = "https://github.com/NixOS/nixpkgs-channels";
  ref = "nixos-19.09";
  # Commit hash for nixos-19.09 as of 2019-10-10
  # `git ls-remote https://github.com/nixos/nixpkgs-channels nixos-19.09`
  rev = "9bbad4c6254513fa62684da57886c4f988a92092";
}) {
  overlays = [
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
             ];
           };
         };
       };
    })
  ];
};

mkShell {
  name = "XCFun";
  nativeBuildInputs = [
    ccache
    clang
    cmake
    gcc
    gfortran
    swig
  ];
  buildInputs = [
    bundler
    clang-analyzer
    doxygen
    graphviz
    lcov
    pipenv
    pybind11
    python3
    travis
  ];
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
