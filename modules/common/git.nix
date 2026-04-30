{
  flake.modules.homeManager.common = { pkgs, ... }: {
    home.packages = with pkgs; [
      delta
      gh
      git
      gitmux
      pre-commit
    ];

    home.file = {
      ".gitmux.conf".source = ../../config/gitmux.conf;
      ".gitconfig".source = ../../config/gitconfig;

      ".config/delta/themes/catppuccin" = {
        source = builtins.fetchGit {
          url = "https://github.com/catppuccin/delta";
          rev = "74b47a345638a2f19b3e5bdb9d7e4984066f9ac7";
        };
        recursive = true;
      };
    };
  };
}
