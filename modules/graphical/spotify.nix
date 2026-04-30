{
  flake.modules.nixos.graphical = {
    networking.firewall.allowedTCPPorts = [ 57621 ];
    networking.firewall.allowedUDPPorts = [ 5353 ];
  };
  flake.modules.homeManager.graphical = { pkgs, ... }: {
    home.packages = with pkgs; [
      spotify
    ];
  };
}
