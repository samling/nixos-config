{
  flake.modules.homeManager.common = { pkgs, ... }: {
    home.packages = with pkgs; [
      devbox
      distrobox
      gcc
      gnumake
      go
      lazygit
      nodejs_22
      python3
      uv
    ];
  };
}
