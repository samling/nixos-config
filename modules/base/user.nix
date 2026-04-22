{ config, ... }:
let
  inherit (config.flake.meta) owner;
in
{
  flake.modules.nixos.base = { pkgs, ... }: {
    users.users.${owner.username} = {
      isNormalUser = true;
      inherit (owner) description;
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
    };
  };
}
