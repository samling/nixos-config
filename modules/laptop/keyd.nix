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
          "f23+leftshift+leftmeta" = "M-A-c";
          rightalt = "C-w";
          "rightshift+rightalt" = "C-t";
          "leftshift+rightalt" = "C-t";
        };
        extraConfig = ''
          [control+alt]
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
