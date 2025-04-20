{ lib, ... }:
{
  applications.democratic-csi = {
    namespace = "democratic-csi";

    helm.releases.democratic-csi = {
      chart = lib.helm.downloadHelmChart {
        repo = "https://democratic-csi.github.io/charts/";
        chart = "democratic-csi";
        version = "0.15.0";
        chartHash = "sha256-csMYTxvcKWHkTwcLmjjrxNx94//PqsnDU3FP/pFOTBM=";
      };

      values = {
        csiDriver = {
          name = "org.democratic-csi.iscsi";
        };

        controller = {
          externalSnapshotter = {
            enabled = false;
          };
        };

        storageClasses = [
          {
            name = "zfs-generic-iscsi-csi";
            defaultClass = true;
            reclaimPolicy = "Delete";
            volumeBindingMode = "Immediate";
            allowVolumeExpansion = true;
            parameters = {
              fsType = "ext4";
            };
            mountOptions = [ ];
            secrets = {
              provisioner-secret = null;
              controller-publish-secret = null;
              node-stage-secret = null;
              node-publish-secret = null;
              controller-expand-secret = null;
            };
          }
        ];

        node = {
          hostPID = true;
          driver = {
            extraEnv = [
              {
                name = "ISCSIADM_HOST_STRATEGY";
                value = "nsenter";
              }
              {
                name = "ISCSIADM_HOST_PATH";
                value = "/usr/local/sbin/iscsiadm";
              }
            ];
            iscsiDirHostPath = "/usr/local/etc/iscsi";
            iscsiDirHostPathType = "";
          };
        };

        volumeSnapshotClasses = [ ];

        driver = {
          existingConfigSecret = "democratic-csi-driver";
          config = {
            driver = "zfs-generic-iscsi";
          };
        };
      };
    };

    yamls = [
      (builtins.readFile ./namespace.yaml)
      (builtins.readFile ./democratic-csi-driver.sops.yaml)
    ];
  };

}
