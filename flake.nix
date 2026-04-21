{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland/v0.54.3";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    claude-code.url = "github:sadjow/claude-code-nix";
    asus-fan.url = "github:ThatOneCalculator/asus-5606-fan-state";
    matugen.url = "github:/InioX/Matugen";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  } // (if builtins.pathExists ./private-inputs.nix
        then import ./private-inputs.nix
        else {});

  outputs = inputs@{ flake-parts, import-tree, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } ({ config, lib, ... }: {
      imports = [
        (import-tree.filterNot (lib.hasSuffix "hardware-configuration.nix") ./modules)
        (import-tree.filterNot (lib.hasSuffix "/package.nix") ./pkgs)
      ] ++ lib.optional (builtins.pathExists ./private.nix) ./private.nix;

      options.flake.modules = lib.mkOption {
        type = lib.types.lazyAttrsOf (lib.types.lazyAttrsOf lib.types.deferredModule);
        default = {};
      };

      config = {
        systems = [ "x86_64-linux" ];

        perSystem = { system, ... }: {
          _module.args.pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        };

        flake.nixosConfigurations = {
          xen = nixpkgs.lib.nixosSystem {
            modules = [ config.flake.modules.nixos.xen ];
          };
          "Sam-Desktop" = nixpkgs.lib.nixosSystem {
            modules = [ config.flake.modules.nixos."Sam-Desktop" ];
          };
        };
      };
    });
}
