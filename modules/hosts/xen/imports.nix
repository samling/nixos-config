{ config, ... }:
{
  configurations.nixos.xen.module = {
    imports = [
      ./hardware-configuration.nix
      config.flake.roles.nixos.laptop
    ];
  };
}
