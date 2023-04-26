{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    inputs.utils.lib.eachSystem [
      "x86_64-linux"
      "i686-linux"
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ] (system:
      let
        name = "hm_purge";
        pkgs = import nixpkgs { inherit system; };
      in rec {
        devShells.default = let
          my-python = pkgs.python39;
          python-with-my-packages = my-python.withPackages (p:
            with p; [
              validators
              requests
              autopep8
              python-lsp-server
              debugpy
              black
            ]);
        in pkgs.mkShell {
          buildInputs = [ python-with-my-packages ];
          shellHook = ''
            PYTHONPATH=${python-with-my-packages}/${python-with-my-packages.sitePackages}
          '';
        };
        packages.cssxpd = pkgs.callPackage ./default.nix {
          name = name;
          pkgs = pkgs;
        };
        packages.default = packages.cssxpd;
      });
}
