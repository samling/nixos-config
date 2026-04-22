{
  flake.modules.homeManager.sboynton = { pkgs, ... }: {
    home = {
      username = "sboynton";
      homeDirectory =
        if pkgs.stdenv.hostPlatform.isDarwin then "/Users/sboynton" else "/home/sboynton";
      stateVersion = "24.11";
    };

    programs.home-manager.enable = true;
  };
}
