{
  flake.modules.homeManager.dev-tools = { pkgs, ... }: {
    home.packages = with pkgs; [
      go
      gcc
      gnumake
      lazygit
      nodejs_22
      python3
      uv
    ];
  };
}
