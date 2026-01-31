{ ... }:
{
  imports = [
    ./sops-secrets-operator
    ./tailscale-operator
    ./democratic-csi
    ./romm
    ./kube-prometheus-stack
    ./bichon
  ];
}
