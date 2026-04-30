{ inputs, ... }:
{
  flake.modules.homeManager.common = { pkgs, ... }: {
    imports = [ inputs.nix-index-database.homeModules.default ];

    # Wraps nix-index + comma against the weekly prebuilt database from
    # nix-index-database so `,` and nix-locate work without a 20-minute
    # indexing run. Don't add nix-index or comma to home.packages — the
    # module installs its own wrappers and they'd conflict.
    programs.nix-index.enable = true;
    programs.nix-index-database.comma.enable = true;

    home.packages = with pkgs; [
      nh
      nix-init
      nurl
      statix
    ];
  };
}
