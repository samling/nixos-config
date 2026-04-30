{ lib, ... }:
{
  options.flake.roles = lib.mkOption {
    type = lib.types.lazyAttrsOf (lib.types.lazyAttrsOf lib.types.deferredModule);
    default = {};
  };
}
