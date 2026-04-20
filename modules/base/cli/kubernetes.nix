{
  flake.modules.homeManager.kubernetes = { pkgs, ... }: {
    home.packages = with pkgs; [
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
