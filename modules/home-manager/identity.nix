{ config, ... }:
let
  inherit (config.flake.meta) owner;
in
{
  flake.modules.homeManager.base = { pkgs, ... }: {
    home = {
      inherit (owner) username;
      homeDirectory =
        if pkgs.stdenv.hostPlatform.isDarwin then owner.homeDirectoryDarwin else owner.homeDirectoryLinux;
      stateVersion = owner.homeManagerStateVersion;
    };
  };
}
