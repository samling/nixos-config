{ lib, stdenv, stdenvNoCC, fetchurl, autoPatchelfHook }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mermaid-rs-renderer";
  version = "0.2.2";

  src = fetchurl {
    url = "https://github.com/1jehuang/mermaid-rs-renderer/releases/download/v${finalAttrs.version}/mmdr-x86_64-unknown-linux-gnu.tar.gz";
    hash = "sha256-ql4sXzlGTiUu+mxlSTc0i/hXADQU5Pv4IptaxB3OI/c=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ stdenv.cc.cc.lib ];

  sourceRoot = ".";
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 mmdr $out/bin/mmdr
    runHook postInstall
  '';

  meta = {
    description = "Fast native Rust Mermaid diagram renderer";
    homepage = "https://github.com/1jehuang/mermaid-rs-renderer";
    license = lib.licenses.mit;
    mainProgram = "mmdr";
    platforms = [ "x86_64-linux" ];
  };
})
