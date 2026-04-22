{
  flake.modules.nixos.base = {
    # Shorter stop timeout keeps reboots snappy when a user unit misbehaves.
    systemd.user.extraConfig = ''
      DefaultTimeoutStopSec=10s
    '';
  };
}
