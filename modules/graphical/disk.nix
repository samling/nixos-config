{
  flake.modules.nixos.graphical = {
    services.udisks2.enable = true;
  };

  flake.modules.homeManager.graphical = {
    services.udiskie = {
      enable = true;
      automount = false;
      tray = "auto";
    };
  };
}
