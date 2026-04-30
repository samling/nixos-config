{ config, ... }:
let
  owner = config.flake.meta.owner.username;
in
{
  configurations.nixos.xen.module = {
    imports = [
      ./hardware-configuration.nix
      config.flake.roles.nixos.laptop
    ];

    networking.hostName = "xen";
    nixpkgs.hostPlatform = "x86_64-linux";
    system.stateVersion = "25.11";

    boot.loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "0";
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };

    home-manager.users.${owner}.wayland.windowManager.hyprland.settings.monitor = [
      ",preferred,auto,1.5"
    ];
  };
}
