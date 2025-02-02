{ charts, ... }:
{
  nixidy.resourceImports = [
    ./generated.nix
  ];

  applications.sops-secrets-operator = {
    namespace = "sops";
    createNamespace = true;

    helm.releases.sops = {
      chart = charts.isindir.sops-secrets-operator;

      values = {
        # Mount secret with age keys to operator pod.
        secretsAsFiles = [
          {
            name = "keys";
            mountPath = "/var/lib/sops/age";
            # Secret created manually out of band.
            secretName = "age-keys";
          }
        ];

        # Tell the operator pod where to read age keys.
        extraEnv = [
          {
            name = "SOPS_AGE_KEY_FILE";
            value = "/var/lib/sops/age/keys.txt";
          }
        ];
      };
    };
  };
}
