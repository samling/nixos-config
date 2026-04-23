{
  flake.modules.nixos.dev = { ... }: {
    programs.dconf.enable = true;
  };
}
