{
  description = "ArgoCD configuration with nixidy";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    nixidy.url = "github:arnarg/nixidy";
    nixhelm.url = "github:farcaller/nixhelm";
    talhelper.url = "github:budimanjojo/talhelper";
  };

  outputs =
    inputs@{
      flake-parts,
      treefmt-nix,
      nixidy,
      nixhelm,
      talhelper,
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
              buildInputs = [ 
                nixidy.packages.${system}.default
                talhelper.packages.${system}.default
              ];
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

          generators = lib.genAttrs config.systems (
            system:
            (withSystem system (
              { pkgs, ... }:
              {
                cilium = nixidy.packages.${system}.generators.fromCRD {
                  name = "cilium";
                  src = pkgs.fetchFromGitHub {
                    owner = "cilium";
                    repo = "cilium";
                    rev = "v1.16.6";
                    hash = "sha256-aNBKCVAWsd7n86xaR5/d2s9pYu1TRGMWYLxZ+9BYCPY=";
                  };
                  crds = [
                    "pkg/k8s/apis/cilium.io/client/crds/v2/ciliumnetworkpolicies.yaml"
                    "pkg/k8s/apis/cilium.io/client/crds/v2/ciliumclusterwidenetworkpolicies.yaml"
                  ];
                };
                tailscale = nixidy.packages.${system}.generators.fromCRD {
                  name = "tailscale";
                  src = pkgs.fetchFromGitHub {
                    owner = "tailscale";
                    repo = "tailscale";
                    rev = "v1.78.3";
                    hash = "sha256-n2XezODpMl9ayKmY1jpyrJMeRD7kxEKdebHyyqZ5x64=";
                  };
                  crds = [ "cmd/k8s-operator/deploy/crds/tailscale.com_proxyclasses.yaml" ];
                };
                sops = nixidy.packages.${system}.generators.fromCRD {
                  name = "sops";
                  src = nixhelm.chartsDerivations.${system}.isindir.sops-secrets-operator;
                  crds = [ "crds/isindir.github.com_sopssecrets.yaml" ];
                };

              }
            ))
          );
        };
      }
    );
}
