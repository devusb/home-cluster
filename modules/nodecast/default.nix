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

  applications.pluto-for-channels = {
    namespace = "nodecast";

    resources = {
      deployments.pluto-for-channels = builtins.head (lib.kube.fromYAML (builtins.readFile ./pluto/deployment.yaml));
      services.pluto-for-channels = builtins.head (lib.kube.fromYAML (builtins.readFile ./pluto/service.yaml));
    };

    yamls = [
      (builtins.readFile ./pluto/pluto-secret.sops.yaml)
    ];
  };
}
