{ ... }:
{
  imports = [
    ./cilium
    ./sops-secrets-operator
    ./tailscale-operator
    ./democratic-csi
  ];
}
