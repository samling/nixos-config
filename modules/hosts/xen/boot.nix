{
  configurations.nixos.xen.module = {
    boot.loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "0";
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };
  };
}
