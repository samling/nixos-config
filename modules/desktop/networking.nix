{
  flake.modules.homeManager.desktop = { pkgs, ... }: {
    home.packages = with pkgs; [ networkmanagerapplet ];
  };
}
