{ lib, stdenv, stdenvNoCC, fetchurl, autoPatchelfHook, libfido2 }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "teleport-bin";
  version = "18.7.2";

  src = fetchurl {
    url = "https://cdn.teleport.dev/teleport-v${finalAttrs.version}-linux-amd64-bin.tar.gz";
    hash = "sha256-z/ssZmD5Oy4ipZZglSSJ/XV+rLMrpv6+WsjfA4AkV2Q=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ libfido2 stdenv.cc.cc.lib ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    for bin in teleport tctl tsh tbot fdpass-teleport; do
      install -Dm755 "$bin" "$out/bin/$bin"
    done
    runHook postInstall
  '';

  meta = {
    description = "Teleport access platform (upstream prebuilt binaries)";
    homepage = "https://goteleport.com";
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
    mainProgram = "tsh";
  };
})
