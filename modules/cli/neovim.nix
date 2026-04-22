{
  flake.modules.homeManager.base = { pkgs, ... }: {
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
    ];

    home.file.".config/nvim" = {
      source = ../../config/nvim;
      recursive = true;
    };
  };
}
