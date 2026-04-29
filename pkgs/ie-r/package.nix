{ lib, stdenvNoCC, fetchurl, unzip }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ie-r";
  version = "0.1.1";

  src = fetchurl {
    url = "https://github.com/miaupaw/ie-r/releases/download/v${finalAttrs.version}/ie-r-v${finalAttrs.version}.zip";
    hash = "sha256-7Zp1QYP91RnPniCG8ayYp+Bto9aXvVOnvHPv77LlmWw=";
  };

  nativeBuildInputs = [ unzip ];

  sourceRoot = "ie-r";

  dontConfigure = true;
  dontBuild = true;

  # Upstream ships a self-contained portable bundle: bin/ie-r is a launcher
  # that invokes the bundled ld-linux with --library-path on the bundled
  # libs. Preserve the bin/lib/share layout so the launcher's relative
  # "../lib" / "../share" lookups still work.
  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r bin lib share $out/

    # Drop the generic hicolor index.theme — every icon theme ships one,
    # and home-manager's buildEnv refuses to merge environments where two
    # packages provide the same shared file.
    rm -f $out/share/icons/hicolor/index.theme

    install -Dm644 share/ie-r.desktop $out/share/applications/ie-r.desktop
    sed -i "s|^Exec=.*|Exec=$out/bin/ie-r|" $out/share/applications/ie-r.desktop

    runHook postInstall
  '';

  meta = {
    description = "Pixel-perfect color picker — Wayland/KWin native";
    homepage = "https://github.com/miaupaw/ie-r";
    license = lib.licenses.mit;
    mainProgram = "ie-r";
    platforms = [ "x86_64-linux" ];
  };
})
