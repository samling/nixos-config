{
  flake.modules.homeManager.base = { pkgs, ... }: let
    # Force SHELL=/bin/bash. Under zsh, claude-code's sandbox fails with
    # "permission denied: /proc/self/fd/3" on every bash invocation.
    claude-code-wrapped = pkgs.symlinkJoin {
      name = "claude-code-${pkgs.claude-code.version or "wrapped"}";
      paths = [ pkgs.claude-code ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/claude --set SHELL /bin/bash
      '';
    };
  in {
    home.packages = with pkgs; [
      bat
      bc
      btop
      claude-code-wrapped
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
