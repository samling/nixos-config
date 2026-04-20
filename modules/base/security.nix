{ config, ... }:
{
  flake.modules.nixos.security = {
    imports = with config.flake.modules.nixos; [
      security-core
      littlesnitch
    ];
  };
}
