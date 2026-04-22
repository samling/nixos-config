{
  flake.modules.homeManager.desktop = { pkgs, ... }: {
    home.packages = with pkgs; [ parsec-bin ];
  };
}
