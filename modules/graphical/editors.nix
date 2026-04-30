{
  flake.modules.homeManager.graphical = { pkgs, ... }: {
    home.packages = with pkgs; [
      obsidian
      vscode-fhs
    ];
  };
}
