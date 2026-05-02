{
  flake.modules.homeManager.common = { pkgs, ... }: {
    home.packages = with pkgs; [
      bitwarden-cli
      doppler
      littlesnitch
      tailscale
      vkv
    ];
  };
}
