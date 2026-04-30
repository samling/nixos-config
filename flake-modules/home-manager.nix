{ config, inputs, ... }:
let
  inherit (config.flake.meta.owner) username;
in
{
  flake.modules.nixos = {
    common = {
      imports = [ inputs.home-manager.nixosModules.home-manager ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${username}.imports = [ config.flake.modules.homeManager.common ];
      };
    };

    graphical = {
      home-manager.users.${username}.imports = [ config.flake.modules.homeManager.graphical ];
    };

    laptop = {
      home-manager.users.${username}.imports = [ config.flake.modules.homeManager.laptop ];
    };

    work = {
      home-manager.users.${username}.imports = [ config.flake.modules.homeManager.work ];
    };
  };
}
