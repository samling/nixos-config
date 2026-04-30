{
  flake.modules.nixos.graphical = {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    services.blueman.enable = true;
  };

  flake.modules.homeManager.graphical = { pkgs, ... }: {
    home.packages = with pkgs; [
      blueman
      bluez
    ];
  };
}
