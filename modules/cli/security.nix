{
  flake.modules.homeManager.base = { pkgs, ... }: {
    home.packages = with pkgs; [
      bitwarden-cli
      doppler
      infisical-bin
      littlesnitch
      tailscale
    ];
  };
}
