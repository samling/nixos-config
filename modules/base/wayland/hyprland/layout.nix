{ ... }:
{
  flake.modules.homeManager.hyprland-layout = {
    wayland.windowManager.hyprland.settings = {
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgb(b4befe)";
        "col.inactive_border" = "rgba(595959aa)";
        resize_on_border = true;
        extend_border_grab_area = 20;
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 5;
        rounding_power = 2;
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow = {
          enabled = true;
          range = 300;
          render_power = 4;
          color = "rgba(1a1a1aaf)";
          offset = "0 40";
          scale = 0.9;
        };

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "linear, 0, 0, 1, 1"
          "md3_standard, 0.2, 0, 0, 1"
          "md3_decel, 0.05, 0.7, 0.1, 1"
          "md3_accel, 0.3, 0, 0.8, 0.15"
          "overshot, 0.05, 0.9, 0.1, 1.1"
          "crazyshot, 0.1, 1.5, 0.76, 0.92"
          "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
          "fluent_decel, 0.1, 1, 0, 1"
          "easeInOutCirc, 0.85, 0, 0.15, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutExpo, 0.16, 1, 0.3, 1"
        ];
        animation = [
          "windows, 1, 3, md3_decel, popin 60%"
          "border, 1, 10, default"
          "fade, 1, 2.5, md3_decel"
          "workspaces, 1, 3.5, easeOutExpo, slide"
          "specialWorkspace, 1, 3, md3_decel, slidevert"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        vfr = true;
        focus_on_activate = true;
      };

      cursor = {
        no_warps = true;
      };

      group = {
        "col.border_active" = "0xD089b4fa";
        groupbar = {
          "col.active" = "0xC089b4fa";
          "col.locked_active" = "0xC089b4fa";
          "col.inactive" = "0xC06c7086";
          "col.locked_inactive" = "0xC06c7086";
          gradient_rounding = 0;
          text_color = "0xFF000000";
          text_color_inactive = "0xFFFFFFFF";
          font_family = "Fira Sans";
          font_size = 14;
          height = 16;
          indicator_height = 0;
          gradients = true;
          render_titles = true;
        };
      };
    };
  };
}
