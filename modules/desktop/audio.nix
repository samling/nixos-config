{
  flake.modules.nixos.desktop = {
    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };
    security.rtkit.enable = true;
  };

  flake.modules.homeManager.desktop = { pkgs, ... }: {
    home.packages = with pkgs; [ pulseaudio ];
  };
}
