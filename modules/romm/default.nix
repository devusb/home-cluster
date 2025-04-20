{ lib, ... }:
{
  applications.romm = {
    namespace = "romm";
    createNamespace = true;

    helm.releases.romm = {
      chart = lib.helm.downloadHelmChart {
        repo = "oci://tccr.io/truecharts";
        chart = "romm";
        version = "10.22.7";
        chartHash = "sha256-sSRdSD5xmBgHYIrZUOVzNvYI1llEhnpIq+CiOzeXvEA=";
      };

      values = {
        image.tag = "3.8.3";
        podOptions = {
          hostUsers = false;
        };
        workload.main.podSpec.containers.main.env = {
          IGDB_CLIENT_ID.secretKeyRef = {
            expandObjectName = false;
            name = "romm-secrets";
            key = "IGDB_CLIENT_ID";
          };
          IGDB_CLIENT_SECRET.secretKeyRef = {
            expandObjectName = false;
            name = "romm-secrets";
            key = "IGDB_CLIENT_SECRET";
          };
          ROMM_AUTH_SECRET_KEY.secretKeyRef = {
            expandObjectName = false;
            name = "romm-secrets";
            key = "ROMM_AUTH_SECRET_KEY";
          };
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
