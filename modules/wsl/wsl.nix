{ config, inputs, ... }:
let
  inherit (config.flake.meta) owner;
in
{
  flake.modules.nixos.wsl = { config, lib, ... }: {
    imports = [ inputs.nixos-wsl.nixosModules.default ];

    wsl = {
      enable = true;
      defaultUser = owner.username;
      wrapBinSh = true;

      extraBin = [
        {
          name = "bash";
          src = config.wsl.binShExe;
        }
      ];
    };

    # WSL2 gets its network stack from Windows; NetworkManager has nothing to do.
    # base sets it via mkDefault, so we force-disable here.
    networking.networkmanager.enable = lib.mkForce false;
  };
}
