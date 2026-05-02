{ config, ... }:
let
  owner = config.flake.meta.owner.username;
in
{
  flake.modules.nixos.laptop = {
    services.keyd = {
      enable = true;
      keyboards.default = {
        ids = [ "*" ];
        settings.main = {
          capslock = "leftcontrol";
          rightalt = "M-A-c"; # clipse-gui
          "f23+leftshift+leftmeta" = "overload(rcopilot, C-w)"; # rcopilot (hold), close tab (tap)
          rightshift = "overload(rshift, rightshift)"; # rshift layer (hold), rightshift (tap; does nothing)
        };
        settings.rshift = {
          "f23+leftshift+leftmeta" = "C-S-t"; # reopen tab
        };
        settings.rcopilot = { # order-independent extra binding
          rightshift = "C-S-t"; # reopen tab
        };
        extraConfig = ''
          [control+alt]
          [shift+alt]
        '';
      };
    };

    # keyd upstream expects a `keyd` group owning /var/run/keyd.socket so non-root
    # tools (e.g. keyd-application-mapper invoking `keyd bind ...`) can connect.
    users.groups.keyd = {};
    users.users.${owner}.extraGroups = [ "keyd" ];
    systemd.services.keyd.serviceConfig.Group = "keyd";

    environment.etc."libinput/local-overrides.quirks".text = ''
      [Serial Keyboards]
      MatchUdevType=keyboard
      MatchName=keyd*keyboard
      AttrKeyboardIntegration=internal
    '';
  };

  flake.modules.homeManager.laptop = { pkgs, ... }: {
    home.packages = [ pkgs.keyd ];

    xdg.configFile."keyd/app.conf".text = ''
      [google-chrome*]
      control+alt.[ = C-S-tab
      control+alt.] = C-tab
      shift+alt.[ = C-S-tab
      shift+alt.] = C-tab
    '';

    systemd.user.services.keyd-application-mapper = {
      Unit = {
        Description = "keyd application mapper";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.keyd}/bin/keyd-application-mapper";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
