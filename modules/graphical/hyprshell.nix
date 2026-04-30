# { inputs, ... }:
# {
#   flake.modules.homeManager.graphical = { pkgs, ... }: {
#     imports = [ inputs.hyprshell.homeModules.hyprshell ];
#
#     # Config lives at ../../config/hyprshell/config.ron and is symlinked
#     # via home.file in hyprland-packages.nix; the module is only used here
#     # to install the package and manage the systemd user unit.
#     programs.hyprshell = {
#       enable = true;
#       systemd.args = "-v";
#     };
#   };
# }

{ }

