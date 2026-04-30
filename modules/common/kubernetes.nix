{
  flake.modules.homeManager.common = { pkgs, ... }: {
    home.file.".config/k9s" = {
      source = ../../config/k9s;
      recursive = true;
    };
    home.packages = with pkgs; [
      k9s
      krew
      kubecolor
      kubectl
      kubectx
      kubernetes-helm
      talhelper
      talosctl
    ];
  };
}
