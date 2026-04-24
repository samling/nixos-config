{ inputs, ... }:
{
  flake.modules.homeManager.desktop = { pkgs, ... }: {
    home.packages = [
      inputs.ie-r.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
