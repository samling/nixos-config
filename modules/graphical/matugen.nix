{ inputs, ... }:
{
  flake.modules.homeManager.graphical = { pkgs, ... }: {
    home.packages = [
      inputs.matugen.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    home.file.".config/matugen" = {
      source = ../../config/matugen;
      recursive = true;
    };
  };
}
