{ lib, ... }:
{
  applications.dispatcharr = {
    namespace = "dispatcharr";
    createNamespace = true;

    resources = {
      deployments.bichon = builtins.head (lib.kube.fromYAML (builtins.readFile ./deployment.yaml));
      services.bichon = builtins.head (lib.kube.fromYAML (builtins.readFile ./service.yaml));
      ingresses.bichon = builtins.head (lib.kube.fromYAML (builtins.readFile ./ingress.yaml));
      persistentVolumeClaims.bichon = builtins.head (lib.kube.fromYAML (builtins.readFile ./pvc.yaml));
    };
  };
}
