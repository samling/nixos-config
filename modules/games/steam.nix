{
  flake.modules.nixos.games = {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };
  };
}
