{
  flake.modules.nixos.common = { ... }: {
    hardware.keyboard.qmk.enable = true;
  };
  flake.modules.homeManager.common = { pkgs, ... }: {
    home.packages = with pkgs; [
      devbox
      distrobox
      gcc
      gnumake
      go
      lazygit
      nodejs_22
      python3
      qmk
      qmk-udev-rules
      qmk_hid
      uv
    ];
  };
}
