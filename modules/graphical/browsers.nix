{
  flake.modules.homeManager.graphical = { pkgs, ... }: {
    home.packages = [
      (pkgs.google-chrome.override {
        commandLineArgs = "--disable-pinch --enable-features=TouchpadOverscrollHistoryNavigation";
      })
    ];

    # Chrome's main process writes exit_type=Normal to its profile only
    # if it receives SIGTERM and runs its own shutdown. On reboot it was
    # getting SIGKILLed first, so the next launch showed "didn't shut
    # down correctly". niri.service is ordered Before=graphical-session
    # .target, so on stop chrome is still alive when this ExecStop runs.
    # We target only the top-level chrome process (no --type= in argv);
    # chrome itself orchestrates shutdown of its renderer/utility kids.
    systemd.user.services.chrome-graceful-shutdown = {
      Unit = {
        Description = "Send SIGTERM to Chrome on session end so it flushes session state";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.coreutils}/bin/true";
        ExecStop = pkgs.writeShellScript "chrome-graceful-stop" ''
          set -u
          main_pid=""
          for pid in $(${pkgs.procps}/bin/pgrep -x chrome 2>/dev/null); do
            args=$(tr '\0' ' ' < /proc/"$pid"/cmdline 2>/dev/null) || continue
            case "$args" in
              *--type=*) ;;
              *) main_pid="$pid"; break ;;
            esac
          done
          [ -n "$main_pid" ] || exit 0
          kill -TERM "$main_pid" 2>/dev/null || exit 0
          for _ in $(seq 1 30); do
            kill -0 "$main_pid" 2>/dev/null || exit 0
            sleep 0.2
          done
        '';
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
