_: {
  perSystem = { pkgs, ... }: {
    packages.mermaid-rs-renderer = pkgs.callPackage ./package.nix { };
  };
}
