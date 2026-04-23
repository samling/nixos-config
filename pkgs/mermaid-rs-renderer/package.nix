{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mermaid-rs-renderer";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "1jehuang";
    repo = "mermaid-rs-renderer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lQCloOhTqqEU8MNrkUmmJFdoOTEE3j5nvZJo21GJlMU=";      # fill in after first build
  };

  cargoHash = "sha256-IETAA/TTbdFaZYHMx8imV0cdnq+2VSgU1a4AdcSuxGM=";    # fill in after first build

  meta = {
    description = "Fast native Rust Mermaid diagram renderer";
    homepage = "https://github.com/1jehuang/mermaid-rs-renderer";
    license = lib.licenses.mit;
    mainProgram = "mmdr";
  };
})
