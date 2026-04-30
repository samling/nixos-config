{
  flake.modules.homeManager.graphical = {
    xdg.desktopEntries."org.gnome.PowerStats" = {
      name = "Power Statistics";
      comment = "Observe power management";
      exec = "gnome-power-statistics";
      icon = "org.gnome.PowerStats";
      terminal = false;
      type = "Application";
      categories = [ "GTK" "System" "Monitor" ];
    };

    xdg.userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;
      download = "$HOME/Downloads";
      documents = "$HOME/Documents";
      desktop = null;
      extraConfig.SCREENSHOTS = "$HOME/Pictures/Screenshots";
    };
  };
}
