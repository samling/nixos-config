{
  flake.modules.homeManager.base = {
    home.file.".config/bat/config".text = ''
      --theme="Catppuccin Mocha"
    '';
  };
}
