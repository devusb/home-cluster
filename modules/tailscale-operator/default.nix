{ charts, ... }:
{
  nixidy.resourceImports = [
    ./generated.nix
  ];

  applications.tailscale-operator = {
    namespace = "tailscale";
    createNamespace = true;

    yamls = [
      (builtins.readFile ./tailscale-secret.sops.yaml)
    ];
  };
}
