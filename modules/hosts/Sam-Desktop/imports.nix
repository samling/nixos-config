{ config, ... }:
{
  configurations.nixos."Sam-Desktop".module = {
    imports = with config.flake.modules.nixos; [
      base
      dev
      virtualization
      work
      wsl
    ];
  };
}
