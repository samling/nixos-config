{
  flake.modules.homeManager.desktop = { pkgs, ... }: {
    home.packages = [
      (pkgs.google-chrome.override {
        commandLineArgs = "--disable-pinch --enable-features=TouchpadOverscrollHistoryNavigation";
      })
    ];
  };
}
