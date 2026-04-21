{ config, inputs, ... }:
{
  flake.modules.nixos.games = { lib, pkgs, ... }: {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };
  };
}
