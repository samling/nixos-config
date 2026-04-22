{
  flake.modules.nixos.dev = { pkgs, ... }: {
    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [
      alsa-lib
      cairo
      cups
      curl
      dbus
      expat
      fontconfig
      freetype
      glib
      gtk3
      icu
      libdrm
      libx11
      libxcomposite
      libxcursor
      libxdamage
      libxext
      libxfixes
      libxi
      libxkbcommon
      libxml2
      libxrandr
      libxrender
      libxtst
      mesa
      nspr
      nss
      openssl
      pango
      stdenv.cc.cc.lib
      zlib
    ];
  };
}
