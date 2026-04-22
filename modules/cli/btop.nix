{
  flake.modules.homeManager.base = {
    home.file.".config/btop/themes".source = builtins.fetchTarball {
      url = "https://github.com/catppuccin/btop/releases/download/1.0.0/themes.tar.gz";
      sha256 = "0gdk6jgzbwh7jsc3h2yvp14860vl0nxvnp6wss7qc25nlq0qprpm";
    };
  };
}
