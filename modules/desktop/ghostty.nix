{ inputs, ... }:
{
  flake.modules.homeManager.desktop = { pkgs, ... }: {
    home.packages = [
      inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    home.file.".config/ghostty" = {
      source = ../../config/ghostty;
      recursive = true;
    };
  };
}
