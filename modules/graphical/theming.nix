{
  flake.modules.nixos.graphical = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      (catppuccin-gtk.override {
        variant = "mocha";
        accents = [ "lavender" ];
        size = "standard";
      })
      papirus-icon-theme
      rose-pine-cursor
      xdg-user-dirs
    ];
  };

  flake.modules.homeManager.graphical = { pkgs, ... }: {
    home.packages = with pkgs; [
      dconf
      glib
      nwg-look
      papirus-icon-theme
      qt6Packages.qt6ct
    ];

    home.pointerCursor = {
      name = "BreezeX-RosePine-Linux";
      package = pkgs.rose-pine-cursor;
      size = 24;
      gtk.enable = true;
      hyprcursor.enable = true;
    };

    gtk = {
      enable = true;
      gtk4.theme = null;
      theme = {
        name = "catppuccin-mocha-lavender-standard";
        package = pkgs.catppuccin-gtk.override {
          variant = "mocha";
          accents = [ "lavender" ];
          size = "standard";
        };
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
    };

    dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

    qt = {
      enable = true;
      platformTheme.name = "qt6ct";
    };
  };
}
