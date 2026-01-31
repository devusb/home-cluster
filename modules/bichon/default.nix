{ lib, ... }:
{
  applications.bichon = {
    namespace = "bichon";
    createNamespace = true;

    resources = {
      deployments.bichon = builtins.head (lib.kube.fromYAML (builtins.readFile ./deployment.yaml));
      services.bichon = builtins.head (lib.kube.fromYAML (builtins.readFile ./service.yaml));
      ingresses.bichon = builtins.head (lib.kube.fromYAML (builtins.readFile ./ingress.yaml));
    };

    yamls = [
      (builtins.readFile ./bichon-secret.sops.yaml)
    ];
  };
}
