{ config, ... }:
let
  owner = config.flake.meta.owner.username;
in
{
  flake.modules.nixos.dev = {
    virtualisation.docker.enable = true;
    users.users.${owner}.extraGroups = [ "docker" ];
  };
}
