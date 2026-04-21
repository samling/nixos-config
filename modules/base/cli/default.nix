{ config, ... }:
{
  flake.modules.homeManager.cli = {
    imports = with config.flake.modules.homeManager; [
      cli-core
      dev-tools
      nix-tools
      git
      zsh
      neovim
      tmux
      kubernetes
      media
      lsd
      command-snippets
    ];
  };
}
