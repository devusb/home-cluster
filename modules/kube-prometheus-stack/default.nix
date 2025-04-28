{ charts, ... }:
{
  applications.kube-prometheus-stack = {
    namespace = "prometheus";

    helm.releases.kube-prometheus-stack = {
      chart = charts.prometheus-community.kube-prometheus-stack;

      values = {
        grafana.enabled = false;
        alertmanager.enabled = false;

        prometheus = {
          ingress = {
            enabled = true;
            ingressClassName = "tailscale";
            paths = [ "/" ];
            tls = [
              { hosts = [ "kube-prom" ]; }
            ];
          };
          prometheusSpec = {
            externalUrl = "https://kube-prom.springhare-egret.ts.net";
            storageSpec.volumeClaimTemplate.spec = {
              accessModes = [ "ReadWriteOnce" ];
              resources.requests.storage = "50Gi";
            };
          };
        };

        kubeEtcd = {
          enabled = true;
          service.selector."k8s-app" = "kube-controller-manager";
        };
      };
    };

    yamls = [
      (builtins.readFile ./namespace.yaml)
    ];
  };
}
