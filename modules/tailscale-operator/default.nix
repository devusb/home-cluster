{ charts, ... }:
{
  nixidy.resourceImports = [
    ./generated.nix
  ];

  applications.tailscale-operator = {
    namespace = "tailscale";
    createNamespace = true;

    helm.releases.tailscale-operator = {
      chart = charts.tailscale.tailscale-operator;
    };

    yamls = [
      (builtins.readFile ./tailscale-secret.sops.yaml)
    ];
  };
}
