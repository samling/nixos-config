{ config, ... }:
let
  inherit (config.flake.meta) owner;
in
{
  flake.modules.nixos.wsl = { pkgs, ... }: {
    services.openssh = {
      enable = true;
      settings.X11Forwarding = true;
    };
    programs.ssh.setXAuthLocation = true;
    environment.systemPackages = [ pkgs.xauth ];

    systemd.tmpfiles.rules = [
      "L+ /usr/bin/xauth - - - - ${pkgs.xauth}/bin/xauth"
      "f  ${owner.homeDirectoryLinux}/.Xauthority 0600 ${owner.username} users -"
    ];
  };
}
