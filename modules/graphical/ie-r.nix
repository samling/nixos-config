_: {
  flake.modules.homeManager.graphical = { pkgs, ... }: {
    home.packages = [ pkgs.ie-r ];
  };
}
