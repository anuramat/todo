{
  description = "todo.txt CLI in python";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      perSystem =
        {
          pkgs,
          ...
        }:
        let
          pkg = pkgs.writeScriptBin "todo" ''
            #!${pkgs.python3}/bin/python3
            ${builtins.readFile ./todo.py}
          '';
        in
        {
          packages.default = pkg;
          treefmt.config.programs = {
            black.enable = true;
            isort.enable = true;
            nixfmt.enable = true;
          };
        };
    };
}
