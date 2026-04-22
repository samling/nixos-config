{
  flake.modules.homeManager.base = { pkgs, ... }: {
    home.packages = with pkgs; [
      fastfetch
      fnm
      gitstatus
      pure-prompt
      zinit
    ];

    home.file = {
      ".zsh" = {
        source = ../../config/zsh;
        recursive = true;
      };

      ".zshrc".source = ../../config/zshrc;

      ".zsh/zinit".source = "${pkgs.zinit}/share/zinit";

      # pure prompt's function files — zsh's `fpath+=(~/.zsh/pure)` in
      # config/zsh/completions.zsh picks up prompt_pure_setup from here.
      ".zsh/pure".source = "${pkgs.pure-prompt}/share/zsh/site-functions";
    };
  };
}
