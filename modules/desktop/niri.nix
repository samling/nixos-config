{ config, inputs, ... }:
  let
    inherit (config.flake.meta) dotfilesPath;
  in
{
  flake.modules.nixos.desktop = {
    programs.niri.enable = true;
  };

  flake.modules.homeManager.desktop = { config, pkgs, ...}: {
    programs.swaylock.package = pkgs.swaylock-effects;
    home.packages = [
      pkgs.swaylock
      pkgs.libinput-gestures
      pkgs.xwayland-satellite
      inputs.niri-float-sticky.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
    xdg.configFile."niri/config.kdl".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/config/niri/config.kdl";
    # xdg.configFile."libinput-gestures.conf".source =
    #   config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/config/niri/libinput-gestures.conf";

    # systemd.user.services.libinput-gestures = {
    #   Unit = {
    #     Description = "libinput-gestures";
    #     After = [ "graphical-session.target" ];
    #     PartOf = [ "graphical-session.target" ];
    #   };
    #   Service = {
    #     ExecStart = "${pkgs.libinput-gestures}/bin/libinput-gestures";
    #     Restart = "always";
    #     RestartSec = "5s";
    #   };
    #   Install.WantedBy = [ "graphical-session.target" ];
    # };
  };
}
