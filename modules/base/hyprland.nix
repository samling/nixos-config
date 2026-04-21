{ config, ... }:
{
  flake.modules.homeManager.hyprland = {
    imports = with config.flake.modules.homeManager; [
      hyprland-core
      hyprland-theme
      hyprland-keywords
      hyprland-input
      hyprland-layout
      hyprland-autostart
      hyprland-keybinds
      hyprland-plugins
      hyprland-windowrules
    ];
  };
}
