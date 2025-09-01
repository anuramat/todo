{
  description = "Todo CLI tool";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = inputs @ { flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-darwin" ];
      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      perSystem = { config, self', inputs', pkgs, system, ... }: {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "todo";
          version = "0.1.0";
          src = ./.;

          buildInputs = [ pkgs.python3 ];

          installPhase = ''
            mkdir -p $out/bin
            cp todo.py $out/bin/todo
            chmod +x $out/bin/todo
          '';
        };

        treefmt.config = {
          projectRootFile = "flake.nix";
          programs.black = {
            enable = true;
            package = pkgs.python3Packages.black;
          };
        };
      };
    };
}