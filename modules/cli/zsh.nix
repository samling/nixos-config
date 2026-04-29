{ config, ... }:
let
  inherit (config.flake.meta) dotfilesPath;
in
{
  flake.modules.homeManager.base = { config, pkgs, ... }: {
    home.packages = with pkgs; [
      fastfetch
      fnm
      gitstatus
      pure-prompt
      zinit
    ];

    home.file = {
      ".zsh" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/config/zsh";
      };

      ".zshrc".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/config/zshrc";

      # Lives outside ~/.zsh because that directory is itself an
      # out-of-store symlink into the dotfiles repo — home-manager won't
      # write store-managed files through a symlink leading outside $HOME.
      ".local/share/zsh/zinit".source = "${pkgs.zinit}/share/zinit";
      ".local/share/zsh/pure".source = "${pkgs.pure-prompt}/share/zsh/site-functions";
    };
  };
}
