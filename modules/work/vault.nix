{
  flake.modules.homeManager.work = { pkgs, lib, ... }: {
    home.packages = with pkgs; [
      vault-bin
    ] ++ lib.optional (pkgs ? nvault) pkgs.nvault;
  };
}
