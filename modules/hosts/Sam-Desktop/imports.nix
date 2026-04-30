{ config, ... }:
{
  configurations.nixos."Sam-Desktop".module = {
    imports = with config.flake.modules.nixos; [
      common
      dev
      virtualization
      work
      wsl
    ];
  };
}
