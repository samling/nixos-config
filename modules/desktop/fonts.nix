{
  flake.modules.homeManager.desktop = { pkgs, ... }: {
    home.packages = with pkgs; [
      nerd-fonts.iosevka
      nerd-fonts.jetbrains-mono
    ];
  };
}
