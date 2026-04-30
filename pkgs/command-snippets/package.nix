{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "command-snippets";
  version = "0.1.1";

  src = fetchurl {
    url = "https://github.com/samling/command-snippets/releases/download/v${finalAttrs.version}/cs-v${finalAttrs.version}-linux-amd64.tar.gz";
    hash = "sha256-cwKrLl0AMCT7CBEaoNNKZ97bKu7rtck1bYLYmILO1X4=";
  };

  sourceRoot = ".";
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 cs $out/bin/cs
    runHook postInstall
  '';

  meta = {
    description = "Fuzzy-searchable command snippet manager";
    homepage = "https://github.com/samling/command-snippets";
    mainProgram = "cs";
    platforms = [ "x86_64-linux" ];
  };
})
