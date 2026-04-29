{
  flake.modules.homeManager.base = { pkgs, ... }: {
    home.packages = with pkgs; [
      bitwarden-cli
      doppler
      littlesnitch
      tailscale
    ];
  };
}
