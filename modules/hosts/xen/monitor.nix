{ config, ... }:
let
  owner = config.flake.meta.owner.username;
in
{
  configurations.nixos.xen.module = {
    home-manager.users.${owner}.wayland.windowManager.hyprland.settings.monitor = [
      ",preferred,auto,1.5"
    ];
  };
}
