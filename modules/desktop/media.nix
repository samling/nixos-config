{
  flake.modules.homeManager.desktop = { pkgs, ... }: {
    home.packages = with pkgs; [
      obs-studio
      playerctl
    ];
  };
}
