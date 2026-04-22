{
  flake.modules.homeManager.desktop = { pkgs, ... }: {
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
