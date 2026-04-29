_: {
  perSystem = { pkgs, ... }: {
    packages.ie-r = pkgs.callPackage ./package.nix { };
  };
}
