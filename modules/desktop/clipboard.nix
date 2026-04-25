{
  # Clipboard daemons run as systemd user services bound to
  # graphical-session.target so they follow the compositor lifecycle
  # regardless of which wayland WM is in use.
  flake.modules.homeManager.desktop = { pkgs, ... }: {
    home.packages = with pkgs; [
      clipse
      clipse-gui
      # copyq
      wl-clipboard
      wtype
    ];

    home.file.".config/clipse" = {
      source = ../../config/clipse;
      recursive = true;
    };

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

      # clipse's `-listen` just spawns two `wl-paste --watch clipse -wl-store`
      # processes as detached children and exits, which Type=simple can't
      # supervise. We run those watchers directly so each one is a real
      # foregrounded systemd-managed process with proper restart semantics.
      clipse-watch-text = {
        Unit = {
          Description = "clipse text clipboard watcher";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste -t text --watch ${pkgs.clipse}/bin/clipse -wl-store";
          Restart = "on-failure";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };

      clipse-watch-image = {
        Unit = {
          Description = "clipse image clipboard watcher";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste -t image/png --watch ${pkgs.clipse}/bin/clipse -wl-store";
          Restart = "on-failure";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };

      # copyq = {
      #   Unit = {
      #     # Running copyq alongside wl-paste/clipse stabilises clipboard
      #     # handoff between wayland clients (observed: other managers hang
      #     # on write without copyq present).
      #     Description = "CopyQ clipboard server";
      #     PartOf = [ "graphical-session.target" ];
      #     After = [ "graphical-session.target" ];
      #   };
      #   Service = {
      #     Environment = "QT_QPA_PLATFORM=xcb";
      #     ExecStart = "${pkgs.copyq}/bin/copyq --start-server";
      #     Restart = "on-failure";
      #   };
      #   Install.WantedBy = [ "graphical-session.target" ];
      # };
    };
  };
}
