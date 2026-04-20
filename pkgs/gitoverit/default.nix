{ ... }: {
  perSystem = { pkgs, ... }: {
    packages.gitoverit = pkgs.callPackage ./package.nix { };
  };
}
