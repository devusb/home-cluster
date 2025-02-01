{
  description = "ArgoCD configuration with nixidy";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    nixidy.url = "github:arnarg/nixidy";
    nixhelm.url = "github:farcaller/nixhelm";
  };

  outputs =
    inputs@{
      flake-parts,
      treefmt-nix,
      nixidy,
      nixhelm,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      {
        withSystem,
        config,
        lib,
        ...
      }:
      {
        imports = [
          treefmt-nix.flakeModule
        ];
        systems = [
          "x86_64-linux"
        ];
        perSystem =
          {
            config,
            self',
            inputs',
            pkgs,
            system,
            ...
          }:
          {
            treefmt = {
              settings.global.excludes = [ "*.yaml" ];
              programs.nixfmt.enable = true;
            };

            packages = {
              nixidy = nixidy.packages.${system}.default;
            };

            devShells.default = pkgs.mkShell {
              buildInputs = [ nixidy.packages.${system}.default ];
            };
          };
        flake = {
          nixidyEnvs = lib.genAttrs config.systems (
            system:
            (withSystem system (
              { pkgs, ... }:
              nixidy.lib.mkEnvs {
                inherit pkgs;
                charts = nixhelm.chartsDerivations.${system};
                envs = {
                  prod.modules = [
                    ./configuration.nix
                    ./modules
                  ];
                };
              }
            ))
          );
        };
      }
    );
}
