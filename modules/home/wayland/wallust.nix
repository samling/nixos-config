_:
{
  flake.modules.homeManager.wallust = _: {
    home.file.".config/wallust" = {
      source = ../../../config/wallust;
      recursive = true;
    };
  };
}
