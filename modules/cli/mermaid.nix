{
  flake.modules.homeManager.base = { pkgs, ... }: {
    home.packages = [ pkgs.mermaid-rs-renderer ];
  };
}
