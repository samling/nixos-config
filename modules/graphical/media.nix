{
  flake.modules.homeManager.graphical = { pkgs, ... }: {
    home.packages = with pkgs; [
      obs-studio
      playerctl
    ];
  };
}
