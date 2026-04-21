{ inputs, ... }:
{
  flake.modules.homeManager.hyprland-core = { config, lib, pkgs, ... }: {
    options.my.home.hyprland.monitors = lib.mkOption {
      type = lib.types.lines;
      default = ''
        monitor=,preferred,auto,1.0

        xwayland {
          force_zero_scaling = true
        }
      '';
      description = ''
        Full content written to ~/.config/hypr/hyprland/monitors.conf.
        Override per-host for hidpi / multi-monitor setups.
      '';
    };

    config = {
      home.packages = with pkgs; [
        hyprpolkitagent
        hypridle
        hyprshell
        hyprlock
      ];

      wayland.windowManager.hyprland = {
        enable = true;
        package = null;
        portalPackage = null;

        extraConfig = ''
          source = ~/.config/hypr/hyprland/monitors.conf
        '';

        plugins = [
          inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo
          inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
        ];
      };

      home.file.".config/hypr" = {
        source = ../../../../config/hypr;
        recursive = true;
      };

      home.file.".config/hypr/hyprland/monitors.conf".text = config.my.home.hyprland.monitors;

      # UWSM sources these at session start — sets QT/cursor env vars that
      # nix's other channels (qt.platformTheme, home.pointerCursor) don't
      # reach because UWSM reads its own files.
      home.file.".config/uwsm/env".text = ''
        export QT_QPA_PLATFORM="wayland;xcb"
        export QT_QPA_PLATFORMTHEME="qt6ct"
        export XCURSOR_SIZE=24
      '';

      home.file.".config/uwsm/env-hyprland".text = ''
        export HYPRCURSOR_SIZE=24
        export HYPRCURSOR_THEME=rose-pine-hyprcursor

        export XDG_CURRENT_DESKTOP="Hyprland"
        export XDG_SESSION_TYPE="wayland"
        export XDG_SESSION_DESKTOP="Hyprland"
        export XDG_MENU_PREFIX="Hyprland-"
      '';
    };
  };
}
