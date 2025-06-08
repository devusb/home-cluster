{ lib, ... }:
{
  applications.romm = {
    namespace = "romm";
    createNamespace = true;

    helm.releases.romm = {
      chart = lib.helm.downloadHelmChart {
        repo = "oci://tccr.io/truecharts";
        chart = "romm";
        version = "11.1.1";
        chartHash = "sha256-9xHaiHxboJkle1eBFv/DY9Rs/oFTHq8Y8mSkNDqmhHM=";
      };

      values = {
        image.tag = "3.10.1";
        securityContext.container = {
          runAsUser = 1002;
          runAsGroup = 1002;
        };
        workload.main.podSpec.containers.main.env =
          let
            secretVars = [
              "IGDB_CLIENT_ID"
              "IGDB_CLIENT_SECRET"
              "ROMM_AUTH_SECRET_KEY"
              "OIDC_CLIENT_ID"
              "OIDC_CLIENT_SECRET"
              "OIDC_PROVIDER"
              "OIDC_REDIRECT_URI"
              "OIDC_SERVER_APPLICATION_URL"
            ];
          in
          lib.genAttrs secretVars (var: {
            secretKeyRef = {
              expandObjectName = false;
              name = "romm-secrets";
              key = var;
            };
          })
          // {
            OIDC_ENABLED = true;
            DISABLE_CSRF_PROTECTION = true;
          };
        persistence.library = {
          enabled = true;
          mountPath = "/romm/library";
          type = "nfs";
          server = "100.117.238.67";
          path = "/r2d2_0/media/Roms";
        };
      };
    };

    yamls = [
      (builtins.readFile ./romm-secret.sops.yaml)
      (builtins.readFile ./ingress.yaml)
    ];
  };
}
