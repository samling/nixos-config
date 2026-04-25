{
  flake.modules.homeManager.base = { pkgs, ... }: {
    home.packages = with pkgs; [
      bitwarden-cli
      doppler
      infisical
      littlesnitch
      tailscale
    ];
  };
}
