{ ... }:
{
  flake.modules.homeManager.hyprland-input = {
    wayland.windowManager.hyprland.settings = {
      input = {
        kb_layout = "us";
        kb_options = "numpad:mac";

        follow_mouse = 1;
        mouse_refocus = 0;

        accel_profile = "adaptive";
        sensitivity = 0;

        touchpad = {
          natural_scroll = true;
          tap-to-click = false;
          tap-and-drag = false;
          clickfinger_behavior = true;
          scroll_factor = 0.6;
        };
      };

      gesture = [
        "3, horizontal, workspace"
        "2, pinchin, dispatcher, exec, ~/.config/hypr/scripts/gestures.sh pinchin"
        "2, pinchout, dispatcher, exec, ~/.config/hypr/scripts/gestures.sh pinchout"
        "4, left, dispatcher, exec, ~/.config/hypr/scripts/gestures.sh left"
        "4, right, dispatcher, exec, ~/.config/hypr/scripts/gestures.sh right"
      ];
      hyprexpo-gesture = "3, up, expo";

      device = [
        { name = "logitech-g-pro--1"; accel_profile = "flat"; }
        # Disable touchscreen on Zenbook S16
        { name = "elan9008:00-04f3:433b"; enabled = false; }
      ];
    };
  };
}
