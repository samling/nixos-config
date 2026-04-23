{ config, ... }:
{
  configurations.nixos.xen.module = {
    imports = [ ./hardware-configuration.nix ] ++ (with config.flake.modules.nixos; [
      base
      desktop
      dev
      games
      laptop
      tailscale
      virtualization
    ]);
  };
}
