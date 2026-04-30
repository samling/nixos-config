{
  flake.modules.homeManager.common = {
    home.file.".config/bat/config".text = ''
      --theme="Catppuccin Mocha"
    '';
  };
}
