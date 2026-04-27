{ config, inputs, ... }:
  let
    inherit (config.flake.meta) dotfilesPath;
  in
{
  # niri-flake's NixOS module injects `homeModules.config` into
  # `home-manager.sharedModules`, so `programs.niri.settings` is already
  # available under home-manager without importing `homeModules.niri`.
  # Importing the latter would set `xdg.portal.enable = true` at the user
  # level, conflicting with the home-manager hyprland module's `false`.
  flake.modules.nixos.desktop = { pkgs, ... }: {
    imports = [ inputs.niri-flake.nixosModules.niri ];
    programs.niri = {
      enable = true;
      # niri-flake's `niri-stable` is pinned to v25.08; `niri-unstable`
      # tracks main and matches the current config schema. Both are
      # covered by the niri.cachix.org substituter.
      package = inputs.niri-flake.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable;
    };
  };

  flake.modules.homeManager.desktop = { config, pkgs, ...}: {
    programs.swaylock.package = pkgs.swaylock-effects;
    home.packages = with pkgs; [
      swaylock
      libinput-gestures
    ];
    xdg.configFile."niri/config.kdl".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/config/niri/config.kdl";
    xdg.configFile."libinput-gestures.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/config/niri/libinput-gestures.conf";

    systemd.user.services.libinput-gestures = {
      Unit = {
        Description = "libinput-gestures";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.libinput-gestures}/bin/libinput-gestures";
        Restart = "always";
        RestartSec = "5s";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
