{
  flake.modules.homeManager.graphical = { pkgs, ... }: {
    home.packages = with pkgs; [
      fuzzel
      rofi
      wlogout
      wofi
    ];

    home.file.".config/rofi" = {
      source = ../../config/rofi;
      recursive = true;
    };
  };
}
