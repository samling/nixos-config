{ config, ... }:
{
  flake.modules.homeManager.hyprland = {
    imports = with config.flake.modules.homeManager; [
      hyprland-core
    ];
  };
}
