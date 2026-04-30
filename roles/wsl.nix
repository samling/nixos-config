{ config, ... }: {
  flake.roles.nixos.wsl = {
    imports = with config.flake.modules.nixos; [
      common
      dev
      virtualization
      work
      wsl
    ];
  };
}
