{
  flake.modules.homeManager.base = {
    home.file.".ripgreprc".source = ../../config/ripgreprc;
    home.sessionVariables.RIPGREP_CONFIG_PATH = "$HOME/.ripgreprc";
  };
}
