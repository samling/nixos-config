{
  flake.modules.nixos.desktop = { ... }: {
    security.polkit.enable = true;
  };
  flake.modules.homeManager.desktop = { pkgs, ... }: {
    home.packages = with pkgs; [
      hypridle
      hyprlock
      hyprpolkitagent
      hyprshell
    ];

    home.file.".config/hypr" = {
      source = ../../config/hypr;
      recursive = true;
    };

    home.file.".config/hyprshell" = {
      source = ../../config/hyprshell;
      recursive = true;
    };

    # Enable the package-shipped hyprpolkitagent unit by writing the wants
    # symlink ourselves (equivalent to `systemctl --user enable`).
    xdg.configFile."systemd/user/graphical-session.target.wants/hyprpolkitagent.service".source =
      "${pkgs.hyprpolkitagent}/share/systemd/user/hyprpolkitagent.service";

    systemd.user.services = {
      hypridle = {
        Unit = {
          Description = "Hyprland's idle daemon";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
          ConditionEnvironment = "WAYLAND_DISPLAY";
        };
        Service = {
          ExecStart = "${pkgs.hypridle}/bin/hypridle";
          Restart = "on-failure";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
