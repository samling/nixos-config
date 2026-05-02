{
  flake.modules.nixos.graphical = { pkgs, ... }: {
    services.udev = {
      packages = with pkgs; [
        qmk
        qmk-udev-rules
        qmk_hid
        via
        vial
      ];
    };
  };
  flake.modules.homeManager.graphical = { pkgs, ... }: {
    home.packages = with pkgs; [
      via
      vial
    ];
  };
}
