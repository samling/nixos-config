{
  flake.modules.homeManager.base = { pkgs, ... }: {
    home.packages = with pkgs; [
      bat
      bc
      btop
      cmatrix
      duf
      eza
      fd
      file
      fzf
      gitoverit
      glib
      glow
      htop
      inotify-tools
      jq
      just
      killall
      libnotify
      littlesnitch
      lsof
      nvd
      psmisc
      ranger
      read-edid
      ripgrep
      tailscale
      toofan
      tree
      ts
      unzip
      v4l-utils
      viddy
      watch
      wget
      yq
      zoxide

      # Used by chezmoi apply scoped to ~/.claude and ~/.ssh
      chezmoi
      doppler
    ];
  };
}
