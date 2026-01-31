{ ... }:
{
  applications.bichon = {
    namespace = "bichon";
    createNamespace = true;

    yamls = [
      (builtins.readFile ./bichon-secret.sops.yaml)
    ];
  };
}
