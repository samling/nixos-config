{
  flake.modules.nixos.security-core = { pkgs, ... }: {
    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };

    users.users.sboynton.extraGroups = [ "wireshark" ];
  };
}
