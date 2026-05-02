{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "vkv";
  version = "0.9.3";

  src = fetchurl {
    url = "https://github.com/FalcoSuessgott/vkv/releases/download/v${finalAttrs.version}/vkv_Linux_x86_64.tar.gz";
    hash = "sha256-ZGypOQ+WIQoGWzO/7WIhXIplZ9QUUuaImMuD3Kl1doI=";
  };

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -Dm755 vkv "$out/bin/vkv"
    install -Dm644 LICENSE "$out/share/licenses/${finalAttrs.pname}/LICENSE"
    runHook postInstall
  '';

  meta = {
    description = "List, compare, move, import, document, backup & encrypt secrets from a HashiCorp Vault KV engine";
    homepage = "https://github.com/FalcoSuessgott/vkv";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "vkv";
  };
})
