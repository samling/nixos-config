{ lib, stdenvNoCC, fetchurl, installShellFiles, testers }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "infisical-bin";
  version = "0.43.78";

  src = fetchurl {
    url = "https://github.com/Infisical/cli/releases/download/v${finalAttrs.version}/cli_${finalAttrs.version}_linux_amd64.tar.gz";
    hash = "sha256-TLp+iL7/9/q0S8Rb+aDY/jB9hXSCZ6THbCXety84vnQ=";
  };

  nativeBuildInputs = [ installShellFiles ];

  sourceRoot = ".";
  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  doCheck = true;
  checkPhase = "./infisical --version";

  installPhase = ''
    runHook preInstall
    install -Dm755 infisical $out/bin/infisical
    installManPage manpages/infisical.1.gz
    installShellCompletion completions/infisical.{bash,fish,zsh}
    runHook postInstall
  '';

  passthru = {
    updateScript = ./update.sh;
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
  };

  meta = {
    description = "Official Infisical CLI (upstream prebuilt binary)";
    homepage = "https://github.com/Infisical/cli";
    license = lib.licenses.mit;
    mainProgram = "infisical";
    platforms = [ "x86_64-linux" ];
  };
})
