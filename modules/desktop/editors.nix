{
  flake.modules.homeManager.desktop = { pkgs, ... }: {
    home.packages = with pkgs; [
      obsidian
      vscode-fhs
    ];
  };
}
