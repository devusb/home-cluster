{ lib, ... }:
{
  applications.nextcloud = {
    namespace = "nextcloud";
    createNamespace = true;

    helm.releases.nextcloud = {
      chart = lib.helm.downloadHelmChart {
        repo = "https://nextcloud.github.io/helm/";
        chart = "nextcloud";
        version = "6.6.10";
        chartHash = "sha256-yVpfmUt5JUYrpkVDq+w5SAZkqwkZ9D+fz5Iv540h+o0=";
      };

      values = {
        ingress = {
          enabled = true;
          className = "tailscale";
          tls = [
            { hosts = [ "nextcloud.springhare-egret.ts.net" ]; }
          ];
        };

        nextcloud = {
          host = "nextcloud.springhare-egret.ts.net";
          existingSecret = {
            enabled = true;
            secretName = "nextcloud-secrets";
            usernameKey = "username";
            passwordKey = "password";
          };
        };

        phpClientHttpsFix.enabled = true;

        persistence.enabled = true;
      };
    };

    yamls = [
      (builtins.readFile ./nextcloud-secret.sops.yaml)
    ];
  };
}
