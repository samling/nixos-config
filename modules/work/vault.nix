{
  flake.modules.homeManager.work = { pkgs, ... }: {
    home.packages = with pkgs; [
      nvault
      vault-bin
    ];
  };
}
