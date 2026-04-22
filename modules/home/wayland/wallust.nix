{ ... }:
{
  flake.modules.homeManager.wallust = { ... }: {
    home.file.".config/wallust" = {
      source = ../../../config/wallust;
      recursive = true;
    };
  };
}
