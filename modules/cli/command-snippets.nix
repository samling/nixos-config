{
  flake.modules.homeManager.base = { pkgs, ... }: {
    home.packages = with pkgs; [ command-snippets ];

    home.file.".config/cs" = {
      source = ../../config/cs;
      recursive = true;
    };
  };
}
