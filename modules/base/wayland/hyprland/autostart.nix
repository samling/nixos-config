{ ... }:
{
  flake.modules.homeManager.hyprland-autostart = {
    # Pass env vars to uwsm, e.g. SHOW_DEFAULT_ICON=true uwsm app -- hyprswitch ...
    wayland.windowManager.hyprland.settings.exec-once = [
      "uwsm app -s b -- hyprpolkitagent"
      "uwsm app -s b -- hypridle"
      "SHOW_DEFAULT_ICON=true uwsm app -- hyprswitch init --show-title --size-factor 4.5 --workspaces-per-row 5"
      "uwsm app -s b fumon"

      # https://github.com/hyprwm/Hyprland/issues/3134
      "uwsm app -- $HOME/.local/lib/import_env tmux"

      # Auto-launch apps on specific workspaces
      "[workspace 1 silent] uwsm app -- google-chrome-stable"
      "[workspace 2 silent] uwsm app -- ghostty"
      "[workspace 3 silent] uwsm app -- code"
      "[workspace 4 silent] uwsm app -- vesktop"
      "[workspace 5 silent] uwsm app -- obsidian"
    ];
  };
}
