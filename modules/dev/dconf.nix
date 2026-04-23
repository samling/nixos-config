{ config, ... }:
let
  owner = config.flake.meta.owner.username;
in
{
  flake.modules.nixos.dev = { ... }: {
    programs.dconf.enable = true;
    users.users.${owner}.linger = true;
  };
}
