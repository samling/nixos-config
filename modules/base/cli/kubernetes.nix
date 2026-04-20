{
  flake.modules.homeManager.kubernetes = { pkgs, ... }: {
    home.packages = with pkgs; [
      kubernetes-helm
      k9s
      kubectl
      kubecolor
      krew
      kubectx
      talhelper
      talosctl
    ];
  };
}
