_: {
  flake.modules.homeManager.desktop = { pkgs, ... }: {
    home.packages = [ pkgs.ie-r ];
  };
}
