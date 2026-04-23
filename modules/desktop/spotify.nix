{
  flake.modules.nixos.desktop = {
    networking.firewall.allowedTCPPorts = [ 57621 ];
    networking.firewall.allowedUDPPorts = [ 5353 ];
  };
  flake.modules.homeManager.desktop = { pkgs, ... }: {
    home.packages = with pkgs; [
      spotify
    ];
  };
}
