{ lib, stdenvNoCC, fetchurl }:

# Local override of nixpkgs' clipse (currently 1.1.0) until
# https://github.com/NixOS/nixpkgs/pull/484504 lands. Drop this directory
# once unstable ships >= 1.2.1.
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "clipse";
  version = "1.2.1";

  src = fetchurl {
    url = "https://github.com/savedra1/clipse/releases/download/v${finalAttrs.version}/clipse_v${finalAttrs.version}_linux_wayland_amd64.tar.gz";
    hash = "sha256-CFMkDL+o78GnO66/TiAvcNwUyDK7Wot0xlCrQQ4pQAM=";
  };

  sourceRoot = ".";
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 clipse-linux-wayland-amd64 $out/bin/clipse
    runHook postInstall
  '';

  meta = {
    description = "Useful clipboard manager TUI for Unix";
    homepage = "https://github.com/savedra1/clipse";
    license = lib.licenses.mit;
    mainProgram = "clipse";
    platforms = [ "x86_64-linux" ];
  };
})
