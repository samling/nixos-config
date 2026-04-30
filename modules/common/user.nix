{ config, ... }:
let
  inherit (config.flake.meta) owner;
in
{
  flake.modules.nixos.common = { pkgs, ... }: {
    users.users.${owner.username} = {
      isNormalUser = true;
      inherit (owner) description;
      extraGroups = [ "networkmanager" "wheel" "input" ];
      shell = pkgs.zsh;
    };
  };
}
