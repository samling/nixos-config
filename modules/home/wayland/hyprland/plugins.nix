{ ... }:
{
  flake.modules.homeManager.hyprland-plugins = {
    wayland.windowManager.hyprland.settings.plugin = {
      hyprexpo = {
        columns = 3;
        gap_size = 5;
        bg_col = "rgb(111111)";
        workspace_method = "first 1";
      };

      hyprbars = {
        bar_height = 24;
        bar_color = "rgb(1e1e2e)";
        bar_text_size = 12;
        bar_text_font = "Fira Sans";
        bar_button_padding = 8;
        bar_padding = 6;
        bar_precedence_over_border = true;
        bar_part_of_window = true;
        icon_on_hover = true;
        hyprbars-button = [
          "$red, 16, ⠀, hyprctl dispatch killactive"
          "$yellow, 16, ⠀, hyprctl dispatch fullscreen 1"
          "$green, 16, ⠀, hyprctl dispatch togglefloating"
          "$peach, 16, 󰐃, hyprctl dispatch pin"
        ];
      };

      hy3 = {
        autotile.enable = true;

        tabs = {
          height = 24;
          padding = 0;
          radius = 0;
          border_width = 2;
          opacity = 1;
          render_text = true;
          text_font = "Fira Sans SemiBold";
          text_height = 10;
          blur = false;

          "col.active" = "rgba(89B4FAFF)";
          "col.active.text" = "rgba(00000000)";
          "col.active.border" = "rgba(1E1E2EFF)";

          "col.inactive" = "rgba(1E1E2EFF)";
          "col.inactive.text" = "rgba(EFF1F5FF)";
          "col.inactive.border" = "rgba(1E1E2EFF)";

          "col.focused" = "rgba(414141FF)";
          "col.focused.text" = "rgba(EFF1F5FF)";
          "col.focused.border" = "rgba(a6adc8FF)";

          "col.urgent" = "rgba(df8e1dFF)";
          "col.urgent.text" = "rgba(00000000)";
        };
      };
    };
  };
}
