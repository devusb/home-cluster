{
  nixidy.target.repository = "https://github.com/devusb/argocd.git";

  nixidy.target.branch = "main";

  nixidy.defaults.syncPolicy = {
    autoSync = {
      enabled = true;
      prune = true;
      selfHeal = true;
    };
  };

}
