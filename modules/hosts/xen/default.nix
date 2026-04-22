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
      tailscale
    ]);

    networking.hostName = "xen";
    nixpkgs.hostPlatform = "x86_64-linux";

    boot.loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "0";
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };

    home-manager.users.sboynton = {
      imports = with config.flake.modules.homeManager; [
        cli
        games
        hyprland
        wayland
        sboynton
      ];

      wayland.windowManager.hyprland.settings.monitor = [
        ",preferred,auto,1.5"
      ];
    };

    system.stateVersion = "25.11";
  };
}
