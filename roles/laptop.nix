{ config, ... }: {
  flake.roles.nixos.laptop = {
    imports = with config.flake.modules.nixos; [
      common
      graphical
      dev
      games
      laptop
      tailscale
      virtualization
    ];
  };
}
