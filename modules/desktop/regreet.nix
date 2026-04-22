{
  flake.modules.nixos.desktop = { lib, ... }: {
    programs.regreet = {
      enable = true;
      settings = {
        GTK = {
          application_prefer_dark_theme = true;
          cursor_theme_name = lib.mkForce "BreezeX-RosePine-Linux";
          font_name = lib.mkForce "Cantarell 16";
          icon_theme_name = lib.mkForce "Papirus-Dark";
          theme_name = lib.mkForce "catppuccin-mocha-lavender-standard";
        };
        commands = {
          reboot = [ "systemctl" "reboot" ];
          poweroff = [ "systemctl" "poweroff" ];
        };
        appearance = {
          greeting_msg = "Welcome back!";
        };
        widget.clock = {
          format = "%a %H:%M";
          resolution = "500ms";
          timezone = "America/Los_Angeles";
          label_width = 150;
        };
      };
    };
  };
}
