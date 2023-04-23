{ pkgs, name, ... }:
let
  my-python = pkgs.python39;
  python-with-my-packages =
    my-python.withPackages (p: with p; [ validators requests ]);
  wrapper = pkgs.writeScriptBin "${name}" ''
    export PYTHONPATH=${python-with-my-packages}/${python-with-my-packages.sitePackages}
    ${my-python}/bin/python ${./main.py} $@'';
in pkgs.stdenv.mkDerivation {
  name = name;
  buildInputs = [ python-with-my-packages ];
  dontUnpack = true;
  installPhase = "install -Dm755 ${wrapper}/bin/${name} $out/bin/${name}";
}
