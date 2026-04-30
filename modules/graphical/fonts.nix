{
  flake.modules.homeManager.graphical = { pkgs, ... }: {
    home.packages = with pkgs; [
      nerd-fonts.iosevka
      nerd-fonts.jetbrains-mono
    ];
  };
}
