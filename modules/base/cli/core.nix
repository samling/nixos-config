{
  flake.modules.homeManager.cli-core = { pkgs, ... }: {
    home.packages = with pkgs; [
      bat
      wget
      watch
      viddy
      killall
      read-edid
      lsof
      v4l-utils
      libnotify
      glib
      tree
      btop
      htop
      zoxide
      tailscale
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
      gitoverit
      littlesnitch

      # Used by chezmoi apply scoped to ~/.claude and ~/.ssh
      chezmoi
      doppler
    ];

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    home.file.".config/bat/config".text = ''
      --theme="Catppuccin Mocha"
    '';

    home.file.".ripgreprc".source = ../../../config/ripgreprc;
    home.sessionVariables.RIPGREP_CONFIG_PATH = "$HOME/.ripgreprc";

    # Opt out of Teleport client auto-updates. CAU downloads a generic-Linux
    # tsh into ~/.tsh/bin that can't run on NixOS (no dynamic loader);
    # keep the autoPatchelf'd teleport-bin from PATH instead.
    home.sessionVariables.TELEPORT_TOOLS_VERSION = "off";

    home.file.".config/btop/themes".source = builtins.fetchTarball {
      url = "https://github.com/catppuccin/btop/releases/download/1.0.0/themes.tar.gz";
      sha256 = "0gdk6jgzbwh7jsc3h2yvp14860vl0nxvnp6wss7qc25nlq0qprpm";
    };
  };
}
