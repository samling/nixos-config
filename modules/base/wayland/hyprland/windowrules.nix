{ ... }:
{
  flake.modules.homeManager.hyprland-windowrules = {
    # Block-form windowrule/layerrule with match:* selectors render
    # awkwardly through nix settings — keep as literal hyprlang.
    wayland.windowManager.hyprland.extraConfig = ''
      # --- Layer rules ---

      # Disable blur on quickshell layer surfaces to prevent continuous GPU compositing
      layerrule {
        name = quickshell-noblur
        match:namespace = ^quickshell:.*$
        blur = false
      }

      # --- Workspace rules ---

      # No gaps or border when in fullscreen
      workspace = f[1], gapsout:0, gapsin:0,border:0

      # --- Window rules ---

      # Semi-transparent terminal so wallpaper shows through colored backgrounds
      windowrule {
        name = terminal-opacity
        opacity = 0.9
        match:class = ^(com\.mitchellh\.ghostty)$
      }

      # Visually indicate when a window is fullscreen
      windowrule {
        name = windowrule-1
        border_color = rgb(CBA6F7)
        match:fullscreen = 1
      }

      windowrule {
        name = windowrule-2
        border_size = 0
        match:float = 0
        match:workspace = f[1]
      }

      windowrule {
        name = windowrule-3
        rounding = 0
        match:float = 0
        match:workspace = f[1]
      }

      # Only enable hyprbars on floating windows
      windowrule {
        name = windowrule-4
        hyprbars:no_bar = on
        match:float = 0
      }

      # Ignore maximize requests from apps
      windowrule {
        name = windowrule-5
        suppress_event = maximize
        match:class = .*
      }

      # Fix some dragging issues with XWayland
      windowrule {
        name = windowrule-6
        no_focus = on
        match:class = ^$
        match:title = ^$
        match:xwayland = 1
        match:float = 1
        match:fullscreen = 0
        match:pin = 0
      }

      # Highlight pinned windows
      windowrule {
        name = windowrule-7
        border_color = rgb(DF8E1D)
        match:pin = 1
      }

      # Floating pacman/yay update window
      windowrule {
        name = windowrule-8-yay
        float = on
        size = 800 600
        center = on
        border_color = rgb(a6e3a1)
        border_size = 2
        match:class = ghostty-yay-update
      }

      # Floating pacman/paru update window
      windowrule {
        name = windowrule-8-paru
        float = on
        size = 800 600
        center = on
        border_color = rgb(a6e3a1)
        border_size = 2
        match:class = ghostty-paru-update
      }

      # Clipse
      windowrule {
        name = windowrule-9
        match:class = (clipse)
      }

      windowrule {
        name = windowrule-10
        float = on
        center = on
        match:class = (clipse)
      }

      windowrule {
        name = windowrule-11
        size = 622 652
        match:class = (clipse)
      }

      windowrule {
        name = windowrule-12
        size = 600 800
        center = on
        float = on
        match:title = (Clipse GUI)
      }

      # blueman-manager
      windowrule {
        name = windowrule-13
        float = on
        size = 800 600
        center = on
        match:class = (blueman-manager)
      }

      # pavucontrol
      windowrule {
        name = windowrule-14
        float = on
        size = 800 500
        center = on
        match:class = (org.pulseaudio.pavucontrol)
      }

      # Cursor popups
      windowrule {
        name = windowrule-15
        center = on
        match:class = (Cursor)
      }

      windowrule {
        name = chrome-extension-popups
        float = on
        size = 360 480
        move = (monitor_w-380) (monitor_h*0.15)
        match:initial_title = (_crx_.*)
      }

      windowrule {
        name = windowrule-19
        float = on
        match:class = (com.github.hluk.copyq)
      }

      windowrule {
        name = windowrule-20
        float = on
        match:class = (copyq)
      }

      windowrule {
        name = windowrule-21
        float = on
        center = on
        match:class = (feh)
      }

      windowrule {
        name = windowrule-22
        float = on
        match:class = (gnome-power-statistics)
      }

      windowrule {
        name = windowrule-23
        float = on
        match:class = (insync)
      }

      windowrule {
        name = windowrule-24
        float = on
        match:class = (localsend)
      }

      windowrule {
        name = windowrule-25
        float = on
        match:class = (mpv)
      }

      windowrule {
        name = windowrule-26
        float = on
        match:class = (nm-connection-editor)
      }

      windowrule {
        name = windowrule-27
        float = on
        match:class = (nm-openconnect-auth-dialog)
      }

      windowrule {
        name = windowrule-28
        float = on
        match:class = (nwg-look)
      }

      windowrule {
        name = windowrule-29
        float = on
        match:class = (org.gnome.*)
      }

      windowrule {
        name = windowrule-30
        float = on
        match:class = (org.kde.dolphin)
      }

      windowrule {
        name = windowrule-31
        float = on
        match:title = (Picture in picture)
      }

      windowrule {
        name = windowrule-32
        float = on
        match:class = (piper)
      }

      windowrule {
        name = windowrule-34
        float = on
        match:class = (xdg-desktop-portal-gtk)
      }

      windowrule {
        name = chrome-notifications
        float = on
        match:class = ()
        match:title = ()
        move = (monitor_w-window_w-10) (monitor_h*0.05)
        no_initial_focus = on
      }
    '';
  };
}
