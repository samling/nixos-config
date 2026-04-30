{ config, ... }:
{
  configurations.nixos.xen.module = {
    imports = [ ./hardware-configuration.nix ] ++ (with config.flake.modules.nixos; [
      common
      graphical
      dev
      games
      laptop
      tailscale
      virtualization
    ]);
  };
}
