{
  flake.modules.homeManager.common = {
    programs.home-manager.enable = true;

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
