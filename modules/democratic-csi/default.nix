{ charts, ... }:
{
  applications.democratic-csi = {
    namespace = "democratic-csi";
    createNamespace = true;

    # helm.releases.tailscale-operator = {
    #   chart = charts.tailscale.tailscale-operator;
    # };

    yamls = [
      (builtins.readFile ./democratic-csi-driver.sops.yaml)
    ];
  };
}
