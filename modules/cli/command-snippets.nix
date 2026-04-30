{
  flake.modules.homeManager.base = { pkgs, ... }: {
    home.packages = [ pkgs.command-snippets ];

    home.file.".config/cs" = {
      source = ../../config/cs;
      recursive = true;
    };
  };
}
