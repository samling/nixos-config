{ config, inputs, ... }:
{
  flake.modules.nixos.games = { lib, pkgs, ... }: {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };
  };

  flake.modules.homeManager.games = { pkgs, ... }: {
    home.packages = with pkgs; [
      obs-studio
    ];
  };
}
