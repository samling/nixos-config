_: {
  perSystem = { pkgs, ... }: {
    packages.clipse = pkgs.callPackage ./package.nix { };
  };
}
