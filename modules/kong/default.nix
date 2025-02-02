{ lib, ... }:
{
  applications.kong = {
    namespace = "kong";
    createNamespace = true;

    helm.releases.kong = {
      chart = lib.helm.downloadHelmChart {
        repo = "https://charts.konghq.com";
        chart = "ingress";
        version = "0.17.0";
        chartHash = "sha256-0ne15fV13RR61cs+Ey/NpChoTWhVDbWup9FLnoZrraA=";
      };

      values = {
        gateway.proxy.loadBalancerClass = "tailscale";
      };

    };
  };
}
