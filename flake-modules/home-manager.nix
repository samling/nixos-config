{ config, inputs, ... }:
let
  inherit (config.flake.meta.owner) username;
in
{
  flake.modules.nixos = {
    base = {
      imports = [ inputs.home-manager.nixosModules.home-manager ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${username}.imports = [ config.flake.modules.homeManager.base ];
      };
    };

    desktop = {
      home-manager.users.${username}.imports = [ config.flake.modules.homeManager.desktop ];
    };

    laptop = {
      home-manager.users.${username}.imports = [ config.flake.modules.homeManager.laptop ];
    };

    work = {
      home-manager.users.${username}.imports = [ config.flake.modules.homeManager.work ];
    };
  };
}
