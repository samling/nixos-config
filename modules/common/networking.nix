{
  flake.modules.nixos.common = { lib, ... }: {
    networking.networkmanager.enable = lib.mkDefault true;
    services.openssh.enable = lib.mkDefault true;
  };
}
