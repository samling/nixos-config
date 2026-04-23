{ config, ... }:
let
  owner = config.flake.meta.owner.username;
in
{
  flake.modules.nixos.virtualization = {
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
    users.users.${owner}.extraGroups = [ "libvirtd" "kvm" ];
  };
}
