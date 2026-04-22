{
  flake.modules.homeManager.desktop = { pkgs, ... }: {
    home.packages = with pkgs; [ wallust ];

    home.file.".config/wallust" = {
      source = ../../config/wallust;
      recursive = true;
    };
  };
}
