{
  flake.modules.nixos.graphical = {
    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };
    security.rtkit.enable = true;
  };

  flake.modules.homeManager.graphical = { pkgs, ... }: {
    home.packages = with pkgs; [ pulseaudio ];
  };
}
