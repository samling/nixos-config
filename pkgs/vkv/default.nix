_: {
  perSystem = { pkgs, ... }: {
    packages.vkv = pkgs.callPackage ./package.nix { };
  };
}
