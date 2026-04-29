_: {
  perSystem = { pkgs, ... }: {
    packages.infisical-bin = pkgs.callPackage ./package.nix { };
  };
}
