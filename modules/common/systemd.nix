{
  flake.modules.nixos.common = {
    # Shorter stop timeout keeps reboots snappy when a user unit misbehaves.
    systemd.user.extraConfig = ''
      DefaultTimeoutStopSec=10s
    '';

    # Compressed in-RAM swap. With no disk swap configured, a runaway
    # process (e.g. a cold `nix eval` against the toplevel after a
    # flake.lock change) can exhaust RAM and freeze the system before
    # the kernel OOM killer reacts. zram gives the kernel cheap room to
    # spill cold pages.
    zramSwap.enable = true;

    # Have systemd-oomd manage user.slice so runaway user processes get
    # killed cleanly under memory pressure instead of taking the system
    # with them. systemd-oomd is already enabled by default; without
    # this flag it doesn't actually act on user processes.
    systemd.oomd.enableUserSlices = true;
  };
}
