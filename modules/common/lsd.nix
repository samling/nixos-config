{
  flake.modules.homeManager.common = { pkgs, ... }: {
    home.packages = with pkgs; [ lsd ];

    home.file.".config/lsd" = {
      source = ../../config/lsd;
      recursive = true;
    };
  };
}
