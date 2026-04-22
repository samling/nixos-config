{ lib, ... }:
{
  options.flake.meta = lib.mkOption {
    type = lib.types.anything;
  };

  config.flake.meta.owner = {
    username = "sboynton";
    description = "Sam Boynton";
    homeDirectoryLinux = "/home/sboynton";
    homeDirectoryDarwin = "/Users/sboynton";
    stateVersion = "24.11";
  };
}
