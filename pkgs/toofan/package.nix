{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "toofan";
  version = "2.2.0";

  src = fetchurl {
    url = "https://github.com/vyrx-dev/toofan/releases/download/v${finalAttrs.version}/toofan_${finalAttrs.version}_linux_amd64.tar.gz";
    hash = "sha256-zG75MQNsyEYKf6i/4vaMKVfvpU6ZJGMTFVnBJU17UPU=";
  };

  sourceRoot = ".";
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 toofan $out/bin/toofan
    runHook postInstall
  '';

  meta = {
    description = "Minimal, lightning-fast typing TUI";
    homepage = "https://github.com/vyrx-dev/toofan";
    license = lib.licenses.mit;
    mainProgram = "toofan";
    platforms = [ "x86_64-linux" ];
  };
})
