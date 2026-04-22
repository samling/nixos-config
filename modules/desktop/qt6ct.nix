{ config, ... }:
let
  inherit (config.flake.meta) owner;
in
{
  flake.modules.homeManager.desktop = {
    home.file.".config/qt6ct/colors/catppuccin-mocha.conf".text = ''
      [ColorScheme]
      active_colors=#ffcdd6f4, #ff1e1e2e, #ff1e1e2e, #ff313244, #ff585b70, #ff6c7086, #ffcdd6f4, #ffcdd6f4, #ffcdd6f4, #ff1e1e2e, #ff313244, #ff585b70, #ff89b4fa, #ff1e1e2e, #ff89b4fa, #fff38ba8, #ff45475a, #ffcdd6f4, #ff181825, #ffcdd6f4, #80cdd6f4
      disabled_colors=#ff6c7086, #ff1e1e2e, #ff1e1e2e, #ff313244, #ff585b70, #ff6c7086, #ff6c7086, #ff6c7086, #ff6c7086, #ff1e1e2e, #ff313244, #ff585b70, #ff89b4fa, #ff1e1e2e, #ff89b4fa, #fff38ba8, #ff45475a, #ffcdd6f4, #ff181825, #ffcdd6f4, #80cdd6f4
      inactive_colors=#ffcdd6f4, #ff1e1e2e, #ff1e1e2e, #ff313244, #ff585b70, #ff6c7086, #ffcdd6f4, #ffcdd6f4, #ffcdd6f4, #ff1e1e2e, #ff313244, #ff585b70, #ff89b4fa, #ff1e1e2e, #ff89b4fa, #fff38ba8, #ff45475a, #ffcdd6f4, #ff181825, #ffcdd6f4, #80cdd6f4
    '';

    home.file.".config/qt6ct/qt6ct.conf".text = ''
      [Appearance]
      icon_theme=Papirus-Dark
      style=Fusion
      custom_palette=true
      color_scheme_path=${owner.homeDirectoryLinux}/.config/qt6ct/colors/catppuccin-mocha.conf

      [Interface]
      dialog_buttons_have_icons=1
      menus_have_icons=true
      show_shortcuts_in_context_menus=true
      toolbutton_style=4

      [Troubleshooting]
      force_raster_widgets=1
    '';
  };
}
