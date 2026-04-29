{
  flake.modules.nixos.desktop = { pkgs, ... }: {
    services.tumbler.enable = true;
    services.gvfs.enable = true;
    programs.xfconf.enable = true;
    programs.thunar.plugins = with pkgs; [ thunar-archive-plugin thunar-volman ];
  };
  flake.modules.homeManager.desktop = { pkgs, ... }: {
    home.packages = with pkgs; [
      thunar
      gvfs
    ];
  };
}
