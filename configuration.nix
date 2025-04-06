# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, catppuccin, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable flakes
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
    };
  };

  # Enable catppuccin
  catppuccin.flavor = "mocha";
  catppuccin.enable = true;

  # XDG portals
  xdg = {
    autostart.enable = true;
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable upower
  services.upower.enable = true;

  # Configure keyd
  services.keyd = {
    enable = true;
    keyboards.default.settings = {
      main = {
        capslock = "overload(control, esc)";
      };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sboynton = {
    isNormalUser = true;
    description = "Sam Boynton";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      acpi
      bat
      btop
      chezmoi
      delta
      direnv
      duf
      fd
      fnm
      fuzzel
      fzf
      go
      google-chrome
      hypridle
      k3s
      kubectl
      lm_sensors
      lsd
      neovim
      ripgrep
      tmux
      vscode
      waybar
      wezterm
      zellij
      zoxide
      (code-cursor.overrideAttrs (oldAttrs: {
        postFixup = ''
          ${oldAttrs.postFixup or ""}
          substituteInPlace $out/share/applications/cursor.desktop \
            --replace 'Exec=${placeholder "out"}/share/cursor/cursor' 'Exec=${placeholder "out"}/bin/cursor'
          '';
      }))
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # Enable cachix
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    brightnessctl
    clang
    clang-tools
    cmake
    cmakeCurses
    gcc
    git
    glib
    glibc
    gsettings-desktop-schemas
    gtk3
    gtk4
    keyd
    lshw
    pkgs.kitty
    swayosd
    wget
    vim
  ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  fonts.packages = with pkgs; [
    noto-fonts
    iosevka
    nerd-fonts.iosevka
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs = {
    hyprland = {
      enable = true;
    };
    thunar = {
      enable = true;
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };
  services.xserver.videoDrivers = ["nvidia"];

  # Load nvidia drivers for xorg and wayland
  hardware.nvidia = {
    gsp.enable = true;
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false; 
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
  
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 20;

      # May help running hot on power but not on battery
      #TLP_DEFAULT_MODE = "BAT";
      #TLP_PERSISTENT_DEFAULT = 1;

      # Optional helps save long term battery health
      START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 80;  # 80 and above it stops charging
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
