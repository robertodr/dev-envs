let
  hostPkgs = import <nixpkgs> {};
  nixpkgs = (hostPkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs-channels";
    # SHA for latest commit on 2019-03-10 for the nixos-19.03 branch
    rev = "aea9130d2fe8bbf39ed6c9115de2516f83d7e298";
    sha256 = "1w1dg9ankgi59r2mh0jilccz5c4gv30a6q1k6kv2sn8vfjazwp9k";
  });
in
  with import nixpkgs {
    overlays = [(self: super:
      {
      }
    )];
  };

  stdenv.mkDerivation {
    name = "parselglossy";
    buildInputs = [
      pipenv
      python3Packages.ruamel_yaml
      travis
    ];

    src = null;
    shellHook = ''
    SOURCE_DATE_EPOCH=$(date +%s)
    '';
  }
