{ config, ... }:
{
  flake.modules.nixos.xen = {
    imports = [ ./hardware-configuration.nix ] ++ (with config.flake.modules.nixos; [
      asus
      base
      desktop
      docker
      games
      keyd
      nix-ld
      security
    ]);

    networking.hostName = "xen";
    nixpkgs.hostPlatform = "x86_64-linux";

    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.consoleMode = "0";
    boot.loader.systemd-boot.configurationLimit = 10;
    boot.loader.efi.canTouchEfiVariables = true;

    home-manager.users.sboynton = {
      imports = with config.flake.modules.homeManager; [
        asus
        cli
        desktop
        hyprland
        wayland
        keyd
        sboynton
      ];

      wayland.windowManager.hyprland.settings.monitor = [
        ",preferred,auto,1.5"
      ];
    };

    system.stateVersion = "25.11";
  };
}
