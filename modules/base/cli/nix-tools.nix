{
  flake.modules.homeManager.nix = { pkgs, ... }: {
    home.packages = with pkgs; [
      comma
      nh
      nix-init
      nix-index
      nurl
      statix
    ];
  };
}
