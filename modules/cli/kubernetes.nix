{
  flake.modules.homeManager.base = { pkgs, ... }: {
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
