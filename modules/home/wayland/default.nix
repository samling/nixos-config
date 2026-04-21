{ config, ... }:
{
  flake.modules.homeManager.wayland = { pkgs, ... }: {
    imports = with config.flake.modules.homeManager; [
      quickshell
      awww
      rofi
      matugen
    ];

    home.packages = with pkgs; [
      copyq
      clipse
      clipse-gui
      wl-clipboard
      wtype
    ];

    # Clipboard daemons run as systemd user services bound to
    # graphical-session.target so they follow the compositor lifecycle
    # regardless of which wayland WM is in use.
    systemd.user.services = {
      wl-paste-primary = {
        Unit = {
          Description = "Mirror primary selection into clipboard";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste -p -t text --watch ${pkgs.wl-clipboard}/bin/wl-copy";
          Restart = "on-failure";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };

      clipse = {
        Unit = {
          Description = "clipse clipboard history daemon";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.clipse}/bin/clipse -listen-shell";
          Restart = "on-failure";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };

      copyq = {
        Unit = {
          # Running copyq alongside wl-paste/clipse stabilises clipboard
          # handoff between wayland clients (observed: other managers hang
          # on write without copyq present).
          Description = "CopyQ clipboard server";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          Environment = "QT_QPA_PLATFORM=xcb";
          ExecStart = "${pkgs.copyq}/bin/copyq --start-server";
          Restart = "on-failure";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
