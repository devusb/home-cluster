{ charts, ... }:
{
  nixidy.target.rootPath = "./manifests/prod";

  applications.cilium = {
    namespace = "kube-system";
    createNamespace = true;

    helm.releases.cilium = {
      chart = charts.cilium.cilium;

      values = {
        ipam.mode = "kubernetes";
        kubeProxyReplacement = true;
        securityContext = {
          capabilities = {
            ciliumAgent = [
              "CHOWN"
              "KILL"
              "NET_ADMIN"
              "NET_RAW"
              "IPC_LOCK"
              "SYS_ADMIN"
              "SYS_RESOURCE"
              "DAC_OVERRIDE"
              "FOWNER"
              "SETGID"
              "SETUID"
            ];
            cleanCiliumState = [
              "NET_ADMIN"
              "SYS_ADMIN"
              "SYS_RESOURCE"
            ];
          };
        };
        cgroup = {
          autoMount.enabled = false;
          hostRoot = "/sys/fs/cgoup";
        };
        k8sServiceHost = "localhost";
        k8sServicePort = 7445;
        gatewayAPI = {
          enabled = true;
          enableAlpn = true;
          enableAppProtocol = true;
        };
      };
    };
  };
}
