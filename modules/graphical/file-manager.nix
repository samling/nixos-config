{
  flake.modules.nixos.graphical = { pkgs, ... }: {
    services.tumbler.enable = true;
    services.gvfs.enable = true;
    programs.xfconf.enable = true;
    programs.thunar.plugins = with pkgs; [ thunar-archive-plugin thunar-volman ];
  };
  flake.modules.homeManager.graphical = { pkgs, ... }: {
    home.packages = with pkgs; [
      thunar
      gvfs
    ];
  };
}
