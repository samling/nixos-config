{ config, ... }:
let
  inherit (config.flake.meta) owner;
in
{
  flake.modules.nixos.base = { config, ... }: {
    services.tailscale = {
      enable = true;
      extraSetFlags = [ "--operator=${owner.username}" ];
    };
    networking.nftables.enable = true;
    networking.firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };

    # Force tailscaled to use nftables on clean nftables-only systems,
    # avoiding iptables-compat translation-layer issues.
    systemd.services.tailscaled.serviceConfig.Environment = [
      "TS_DEBUG_FIREWALL_MODE=nftables"
    ];

    systemd.network.wait-online.enable = false;
    boot.initrd.systemd.network.wait-online.enable = false;
  };
}
