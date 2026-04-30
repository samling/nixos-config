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
    niri-float-sticky = {
      url = "github:probeldev/niri-float-sticky";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # hyprland-plugins has no version tags and its main branch tracks
    # hyprland-git. Pin to a commit known to build against the hyprland tag
    # above, and bump deliberately when bumping hyprland.
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins/6acc0738f298f5efe40a99db2c12449112d65633";
      inputs.hyprland.follows = "hyprland";
    };
    # hyprshell = {
    #   url = "github:H3rmt/hyprshell?ref=hyprshell-release";
    #   inputs.hyprland.follows = "hyprland";
    # };
    # ghostty's flake pins its own nixpkgs to control the glibc version
    # and Zig/GTK pairing — don't `follows`. Main is the `tip` channel.
    ghostty.url = "github:ghostty-org/ghostty";
    llm-agents.url = "github:numtide/llm-agents.nix";
    #claude-code.url = "github:sadjow/claude-code-nix";
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
  };

  outputs = inputs@{ flake-parts, import-tree, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } ({ lib, ... }: {
      imports = [
        (import-tree ./modules)
        (import-tree.filterNot (lib.hasSuffix "hardware-configuration.nix") ./hosts)
        (import-tree.filterNot (lib.hasSuffix "/package.nix") ./pkgs)
        (import-tree ./flake-modules)
        (import-tree ./roles)
      ] ++ lib.optional (builtins.pathExists /home/sboynton/work-dotfiles/default.nix) /home/sboynton/work-dotfiles/default.nix;

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
      };
    });
}
