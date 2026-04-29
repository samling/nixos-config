{ config, ... }:
  let
    inherit (config.flake.meta) dotfilesPath;
  in
{
  flake.modules.homeManager.base = { config, pkgs, ... }: {
    home.packages = with pkgs; [ tmux ];

    home.file = {
      ".config/tmux/plugins/tpm" = {
        source = fetchGit {
          url = "https://github.com/tmux-plugins/tpm";
          rev = "99469c4a9b1ccf77fade25842dc7bafbc8ce9946";
        };
        recursive = true;
      };

      ".tmux.conf".source =
          config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/config/tmux/tmux.conf";

      ".tmux/scripts" = {
        source = ../../config/tmux/scripts;
        recursive = true;
      };

      ".tmux/kube-tmux" = {
        source = ../../config/tmux/kube-tmux;
        recursive = true;
      };
    };
  };
}
