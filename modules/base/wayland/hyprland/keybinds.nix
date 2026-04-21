{ ... }:
{
  flake.modules.homeManager.hyprland-keybinds = {
    wayland.windowManager.hyprland = {
      settings = {
        "$mainMod" = "SUPER";

        binds.allow_workspace_cycles = true;

        bind = [
          # Window controls
          "$mainMod, W, killactive,"
          "$mainMod, E, exec, uwsm app -- $fileManager"
          "$mainMod, space, exec, $launcher -show drun -run-command \"uwsm app -- {cmd}\""
          "$mainMod, Period, exec, $emoji"
          "$mainMod, F, fullscreenstate, 1,"
          "$mainMod SHIFT, F, fullscreenstate, 2,"
          "$mainMod, S, exec, ~/.config/hypr/scripts/scratchpad"
          "$mainMod SHIFT, S, exec, ~/.config/hypr/scripts/scratchpad -m \"rofi -dmenu\" -g -l"
          "$mainMod, V, togglefloating,"
          "$mainMod SHIFT, P, pin"
          "$mainMod, C, exec, hyprctl dispatch resizeactive exact 50% 50% && hyprctl dispatch centerwindow"
          "$mainMod SHIFT, R, exec, ~/.config/awww/awww_randomize_multi.sh '/home/sboynton/Pictures/Wallpapers' && notify-send \"Cycled wallpaper\""
          "$mainMod SHIFT, P, exec, qs ipc call wallpaper toggle"
          "$mainMod ALT, P, exec, pkill wf-recorder && notify-send \"Stopped screen recording\""
          "$mainMod SHIFT, bracketleft, exec, hyprshade toggle blue-light-filter"
          # NOTE: $rofi is not defined as a keyword — carried over verbatim
          # from the pre-nix config. Likely meant $launcher.
          "$mainMod, Tab, exec, $rofi -show window"
          "$mainMod SHIFT, W, exec, pkill waybar && hyprctl dispatch exec waybar"
          "$mainMod ALT, c, exec, $copyMenu"

          # Screenshots
          ", print, exec, swscreenshot-gui"
          "CONTROL $mainMod, 3, exec, grim $(xdg-user-dir)/Pictures/Screenshots/$(date +'%s_grim.png') && notify-send \"Screenshot saved\""
          "CTRL, print, exec, grim -g \"$(slurp)\" $(xdg-user-dir)/Pictures/Screenshots/$(date +'%s_grim.png') && notify-send \"Screenshot saved\""
          "CTRL $mainMod, 4, exec, grim -g \"$(slurp)\" $(xdg-user-dir)/Pictures/Screenshots/$(date +'%s_grim.png') && notify-send \"Screenshot saved\""

          # Session
          "$mainMod CONTROL ALT, M, exec, wlogout"
          "$mainMod CONTROL ALT, L, exec, $hyprlock"

          # Focus
          "$mainMod, H, movefocus, l"
          "$mainMod, L, movefocus, r"
          "$mainMod, K, movefocus, u"
          "$mainMod, J, movefocus, d"
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"

          # Groups
          "$mainMod, T, togglegroup"
          "$mainMod, U, moveoutofgroup"
          "$mainMod, L, changegroupactive, f"
          "$mainMod, H, changegroupactive, b"
          "$mainMod SHIFT, L, moveintogroup, r"
          "$mainMod SHIFT, H, moveintogroup, l"
          "$mainMod SHIFT, L, movegroupwindow, f"
          "$mainMod SHIFT, H, movegroupwindow, b"

          # Move window
          "$mainMod SHIFT, H, movewindow, l"
          "$mainMod SHIFT, L, movewindow, r"
          "$mainMod SHIFT, K, movewindow, u"
          "$mainMod SHIFT, J, movewindow, d"
          "$mainMod SHIFT, left, movewindow, l"
          "$mainMod SHIFT, right, movewindow, r"
          "$mainMod SHIFT, up, movewindow, u"
          "$mainMod SHIFT, down, movewindow, d"

          # Enter resize mode (submap defined in extraConfig below)
          "$mainMod, R, submap, resize"

          # Switch workspaces
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"
          "$mainMod ALT, 1, workspace, 11"
          "$mainMod ALT, 2, workspace, 12"
          "$mainMod ALT, 3, workspace, 13"
          "$mainMod ALT, 4, workspace, 14"
          "$mainMod ALT, 5, workspace, 15"
          "$mainMod ALT, 6, workspace, 16"
          "$mainMod ALT, 7, workspace, 17"
          "$mainMod ALT, 8, workspace, 18"
          "$mainMod ALT, 9, workspace, 19"
          "$mainMod ALT, 0, workspace, 20"
          "$mainMod, N, workspace, e+1"
          "$mainMod, P, workspace, e-1"

          # Move active window to workspace
          "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
          "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
          "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
          "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
          "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
          "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
          "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
          "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
          "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
          "$mainMod SHIFT, 0, movetoworkspacesilent, 10"
          "$mainMod ALT SHIFT, 1, movetoworkspacesilent, 11"
          "$mainMod ALT SHIFT, 2, movetoworkspacesilent, 12"
          "$mainMod ALT SHIFT, 3, movetoworkspacesilent, 13"
          "$mainMod ALT SHIFT, 4, movetoworkspacesilent, 14"
          "$mainMod ALT SHIFT, 5, movetoworkspacesilent, 15"
          "$mainMod ALT SHIFT, 6, movetoworkspacesilent, 16"
          "$mainMod ALT SHIFT, 7, movetoworkspacesilent, 17"
          "$mainMod ALT SHIFT, 8, movetoworkspacesilent, 18"
          "$mainMod ALT SHIFT, 9, movetoworkspacesilent, 19"
          "$mainMod ALT SHIFT, 0, movetoworkspacesilent, 20"

          # Scratchpad
          "$mainMod, grave, togglespecialworkspace, magic"
          "$mainMod SHIFT, grave, movetoworkspacesilent, special:magic"

          # Scroll workspaces
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"

          # Multimedia (single-shot)
          ",XF86AudioMute, exec, pactl -- set-sink-mute 0 toggle"
          ",XF86AudioMicMute, exec, pactl -- set-source-mute 0 toggle"
        ];

        # Repeating binds (fire on key hold)
        binde = [
          ",XF86AudioLowerVolume, exec, pactl -- set-sink-volume 0 -2%"
          ",XF86AudioRaiseVolume, exec, pactl -- set-sink-volume 0 +2%"
        ];

        # Mouse binds (move/resize with modifier + mouse button)
        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod SHIFT, mouse:272, resizewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        # Locked binds (fire even when screen is locked)
        bindl = [
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPause, exec, playerctl play-pause"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPrev, exec, playerctl previous"
        ];

        # Locked + repeating
        bindle = [
          ",XF86MonBrightnessDown, exec, brightnessctl s 5%-"
          ",XF86MonBrightnessUp, exec, brightnessctl s +5%"
        ];
      };

      # Submaps need the ordered `submap = name / binds / submap = reset`
      # form — can't express via settings attrset.
      extraConfig = ''
        submap = resize
        bind = , H, resizeactive, -5% 0%
        bind = , J, resizeactive, 0% -5%
        bind = , K, resizeactive, 0% 5%
        bind = , L, resizeactive, 5% 0%
        bind = , equal, resizeactive, 5% 5%
        bind = , minus, resizeactive, -5% -5%
        bind = , Return, submap, reset
        bind = , Escape, submap, reset
        submap = reset
      '';
    };
  };
}
