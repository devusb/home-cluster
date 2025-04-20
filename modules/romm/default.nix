{ lib, ... }:
{
  applications.romm = {
    namespace = "romm";
    createNamespace = true;

    yamls = [
      (builtins.readFile ./romm-secret.sops.yaml)
    ];
  };
}
