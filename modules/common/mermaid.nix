{
  flake.modules.homeManager.common = { pkgs, ... }: {
    home.packages = [ pkgs.mermaid-rs-renderer ];
  };
}
