{
  flake.modules.homeManager.dev-tools = { pkgs, ... }: {
    home.packages = with pkgs; [
      go
      gcc
      gnumake
      nodejs_22
      python3
      uv
    ];
  };
}
