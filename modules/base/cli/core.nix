{
  flake.modules.homeManager.cli-core = { pkgs, ... }: {
    home.packages = with pkgs; [
      bat
      wget
      watch
      viddy
      killall
      read-edid
      v4l-utils
      libnotify
      glib
      tree
      btop
      htop
      zoxide
      inotify-tools
      fd
      just
      ripgrep
      duf
      eza
      file
      fzf
      bc
      unzip
      nvd
      cmatrix
      jq
      yq
      claude-code
      toofan
      littlesnitch

      # Used by chezmoi apply scoped to ~/.claude and ~/.ssh
      chezmoi
      doppler
    ];

    home.file.".config/bat/config".text = ''
      --theme="Catppuccin Mocha"
    '';

    home.file.".ripgreprc".source = ../../../config/ripgreprc;
    home.sessionVariables.RIPGREP_CONFIG_PATH = "$HOME/.ripgreprc";

    home.file.".config/btop/themes".source = builtins.fetchTarball {
      url = "https://github.com/catppuccin/btop/releases/download/1.0.0/themes.tar.gz";
      sha256 = "0gdk6jgzbwh7jsc3h2yvp14860vl0nxvnp6wss7qc25nlq0qprpm";
    };
  };
}
