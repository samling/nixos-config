{ config, ... }:
let
  inherit (config.flake.meta) owner;
in
{
  flake.modules.nixos.graphical = { config, lib, pkgs, ... }: {
    options.services.littlesnitch = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable the Little Snitch outbound firewall daemon.";
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.littlesnitch;
        description = "The Little Snitch package to use.";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open TCP port 3031 (web UI) in the firewall.";
      };
    };

    config = {
      programs.wireshark = {
        enable = true;
        package = pkgs.wireshark;
      };

      users.users.${owner.username}.extraGroups = [ "wireshark" ];

      environment.systemPackages = lib.mkIf config.services.littlesnitch.enable [
        config.services.littlesnitch.package
      ];
      systemd.packages = lib.mkIf config.services.littlesnitch.enable [
        config.services.littlesnitch.package
      ];
      systemd.services.littlesnitch.wantedBy = lib.mkIf config.services.littlesnitch.enable [
        "multi-user.target"
      ];

      networking.firewall.allowedTCPPorts = lib.mkIf (
        config.services.littlesnitch.enable && config.services.littlesnitch.openFirewall
      ) [ 3031 ];
    };
  };
}
