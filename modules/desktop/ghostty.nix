{
  flake.modules.homeManager.desktop = { pkgs, ... }: {
    home.packages = with pkgs; [ ghostty ];

    home.file.".config/ghostty" = {
      source = ../../config/ghostty;
      recursive = true;
    };
  };
}
