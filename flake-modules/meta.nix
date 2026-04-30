{ lib, ... }:
let
  owner = {
    username = "sboynton";
    description = "Sam Boynton";
    homeDirectoryLinux = "/home/sboynton";
    homeDirectoryDarwin = "/Users/sboynton";
    homeManagerStateVersion = "24.11";
  };
in
{
  options.flake.meta = lib.mkOption {
    type = lib.types.anything;
  };

  config.flake.meta = {
    inherit owner;
    dotfilesPath = "${owner.homeDirectoryLinux}/dotfiles";
  };
}
