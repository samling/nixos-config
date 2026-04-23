_: {
  perSystem = { pkgs, ... }: {
    packages.claude-seccomp = pkgs.callPackage ./package.nix { };
  };
}
