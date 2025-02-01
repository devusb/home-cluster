{ ... }:
{
  nixidy = {
    target = {
      repository = "https://github.com/devusb/argocd.git";
      branch = "main";
      rootPath = "manifests/prod";
    };
    defaults.syncPolicy = {
      autoSync = {
        enabled = true;
        prune = true;
        selfHeal = true;
      };
    };
  };

}
