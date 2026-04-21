{ ... }:
{
  flake.modules.homeManager.hyprland-keywords = {
    # Command variables referenced by keybindings ($terminal, $launcher, ...).
    wayland.windowManager.hyprland.settings = {
      "$terminal" = "ghostty";
      "$fileManager" = "thunar";
      "$launcher" = ''rofi -icon-theme "Papirus" -show-icons -no-lazy-grab -cache-dir "$HOME/.cache/rofi"'';
      "$emoji" = ''BEMOJI_PICKER_CMD="fuzzel --match-mode exact -d" bemoji -n -t'';
      "$copyMenu" = "clipse-gui";
      "$hyprlock" = "hyprlock";
    };
  };
}
