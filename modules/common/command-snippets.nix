{
  flake.modules.homeManager.common = { pkgs, ... }: {
    home.packages = [ pkgs.command-snippets ];

    home.file.".config/cs" = {
      source = ../../config/cs;
      recursive = true;
    };
  };
}
