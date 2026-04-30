{ config, ... }:
let
  inherit (config.flake.meta) dotfilesPath;
in
{
  flake.modules.homeManager.common = { config, pkgs, ... }: {
    home.packages = with pkgs; [
      neovim
      vim

      # LSP servers
      buf
      dockerfile-language-server
      gopls
      lua-language-server
      nixd
      rust-analyzer
      terraform-ls
      typescript-language-server
      yaml-language-server

      # Formatters
      black
      isort
      shfmt
      stylua

      # Plugins
      typst
      mermaid-cli
    ];

    home.file.".config/nvim" = {
      source = 
        config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/config/nvim";
    };
  };
}
