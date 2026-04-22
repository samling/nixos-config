{
  flake.modules.nixos.desktop = {
    services.upower.enable = true;
    services.power-profiles-daemon.enable = true;
  };

  flake.modules.homeManager.desktop = { pkgs, ... }: {
    home.packages = with pkgs; [
      brightnessctl
      gnome-power-manager
      lm_sensors
    ];
  };
}
