{ config, ... }:
{
  configurations.nixos."Sam-Desktop".module = {
    imports = [ config.flake.roles.nixos.wsl ];
  };
}
