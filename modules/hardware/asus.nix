{ config, inputs, ... }:
let
  owner = config.flake.meta.owner.username;
in
{
  flake.modules.nixos.laptop = { pkgs, ... }: {
    imports = [ inputs.asus-fan.nixosModules.default ];

    services.asus-fan-state = {
      enable = true;
      package = inputs.asus-fan.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };

    services.asusd.enable = true;
    systemd.services.asusd.wantedBy = [ "multi-user.target" ];

    security.sudo.extraRules = [{
      users = [ owner ];
      commands = [{
        command = "/run/current-system/sw/bin/fan_state";
        options = [ "NOPASSWD" "SETENV" ];
      }];
    }];

    # Zenbook UM5606: extended-vblank EDID lets MCLK/FCLK downclock at 120Hz idle.
    # https://wiki.archlinux.org/title/ASUS_Zenbook_UM5606
    hardware.display.edid = {
      enable = true;
      packages = [
        (pkgs.runCommand "edid-mclk-fix" {} ''
          mkdir -p $out/lib/firmware/edid
          cp ${./edid_mclk_fix.bin} $out/lib/firmware/edid/edid_mclk_fix.bin
        '')
      ];
    };
    boot.kernelParams = [ "drm.edid_firmware=eDP-1:edid/edid_mclk_fix.bin" ];
  };

  flake.modules.homeManager.laptop = { pkgs, ... }: {
    home.packages = [
      pkgs.amdgpu_top
      pkgs.asusctl
    ];
  };
}
