{
  flake.modules.nixos.graphical = {
    services.upower.enable = true;
    services.power-profiles-daemon.enable = true;
  };

  flake.modules.homeManager.graphical = { pkgs, ... }: {
    home.packages = with pkgs; [
      brightnessctl
      gnome-power-manager
      lm_sensors
    ];
  };
}
