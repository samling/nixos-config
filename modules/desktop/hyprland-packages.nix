{
  flake.modules.homeManager.desktop = { pkgs, ... }: {
    home.packages = with pkgs; [
      hypridle
      hyprlock
      hyprpolkitagent
      hyprshell
    ];

    home.file.".config/hypr" = {
      source = ../../config/hypr;
      recursive = true;
    };
  };
}
