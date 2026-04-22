{ inputs, ... }:
{
  flake.modules.nixos.wsl = { lib, pkgs, ... }: {
    imports = [ inputs.nixos-wsl.nixosModules.default ];

    wsl.enable = true;
    wsl.defaultUser = "sboynton";

    # WSL2 gets its network stack from Windows; NetworkManager has nothing to do.
    # base sets it via mkDefault, so we force-disable here.
    networking.networkmanager.enable = lib.mkForce false;

    services.openssh = {
      enable = true;
      settings.X11Forwarding = true;
    };
    programs.ssh.setXAuthLocation = true;
    environment.systemPackages = [ pkgs.xauth ];

    systemd.tmpfiles.rules = [
      "L+ /usr/bin/xauth - - - - ${pkgs.xauth}/bin/xauth"
      "f  /home/sboynton/.Xauthority 0600 sboynton users -"
    ];
  };
}
