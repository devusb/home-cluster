{ lib, ... }:
{
  applications.nodecast = {
    namespace = "nodecast";
    createNamespace = true;

    resources = {
      deployments.nodecast = builtins.head (lib.kube.fromYAML (builtins.readFile ./deployment.yaml));
      services.nodecast = builtins.head (lib.kube.fromYAML (builtins.readFile ./service.yaml));
      ingresses.nodecast = builtins.head (lib.kube.fromYAML (builtins.readFile ./ingress.yaml));
      persistentVolumeClaims.nodecast = builtins.head (lib.kube.fromYAML (builtins.readFile ./pvc.yaml));
    };

    yamls = [
      (builtins.readFile ./nodecast-secret.sops.yaml)
    ];
  };
}
