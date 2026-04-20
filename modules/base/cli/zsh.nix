{
  flake.modules.homeManager.zsh = { pkgs, ... }: {
    home.packages = with pkgs; [
      zinit
      pure-prompt
      gitstatus
      fastfetch
      fnm
    ];

    home.file.".zsh" = {
      source = ../../../config/zsh;
      recursive = true;
    };

    home.file.".zshrc".source = ../../../config/zshrc;

    home.file.".zsh/zinit".source = "${pkgs.zinit}/share/zinit";

    # pure prompt's function files — zsh's `fpath+=(~/.zsh/pure)` in
    # config/zsh/completions.zsh picks up prompt_pure_setup from here.
    home.file.".zsh/pure".source = "${pkgs.pure-prompt}/share/zsh/site-functions";
  };
}
