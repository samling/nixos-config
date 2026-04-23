{ lib, stdenv, sandbox-runtime, libseccomp, python3 }:

let
  arch =
    if stdenv.hostPlatform.isx86_64 then "x86_64"
    else if stdenv.hostPlatform.isAarch64 then "aarch64"
    else throw "claude-seccomp: unsupported arch ${stdenv.hostPlatform.system}";
  outDir =
    if stdenv.hostPlatform.isx86_64 then "x64"
    else "arm64";
in
stdenv.mkDerivation {
  pname = "claude-seccomp";
  version = sandbox-runtime.version or "0";

  src = "${sandbox-runtime}/lib/node_modules/@anthropic-ai/sandbox-runtime/vendor/seccomp-src";
  dontUnpack = true;

  nativeBuildInputs = [ python3 ];
  buildInputs = [ libseccomp ];

  buildPhase = ''
    runHook preBuild

    # 1. Generator — links libseccomp dynamically, run once to emit the BPF blob.
    $CC -O2 -Wall -Wextra -o seccomp-unix-block "$src/seccomp-unix-block.c" -lseccomp
    ./seccomp-unix-block seccomp-unix-block.bpf ${arch}

    # 2. Embed the BPF bytes in a C header for apply-seccomp to compile in.
    python3 -c 'import sys
    d = open(sys.argv[1], "rb").read()
    print("static const unsigned char unix_block_bpf[] = {" + ",".join(hex(b) for b in d) + "};")' \
      seccomp-unix-block.bpf > unix-block-bpf.h

    # 3. apply-seccomp — uses only raw <linux/seccomp.h> + libc, so a plain dynamic
    #    link is fine on NixOS: stdenv stamps an RPATH to the nixpkgs glibc and the
    #    binary runs without any external runtime.
    $CC -O2 -Wall -Wextra -I. -o apply-seccomp "$src/apply-seccomp.c"
    $STRIP apply-seccomp

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm0644 seccomp-unix-block.bpf "$out/share/claude-code/seccomp/${outDir}/seccomp-unix-block.bpf"
    install -Dm0755 apply-seccomp           "$out/share/claude-code/seccomp/${outDir}/apply-seccomp"
    runHook postInstall
  '';

  meta = {
    description = "Prebuilt seccomp BPF blob and apply-seccomp helper for Claude Code's unix-socket sandbox filter";
    longDescription = ''
      The nixpkgs sandbox-runtime package only ships C sources under
      vendor/seccomp-src. Claude Code's sandbox check requires a prebuilt BPF
      blob and apply-seccomp binary. This derivation runs the generator and
      produces both artifacts so they can be placed at the paths referenced by
      sandbox.seccomp.{bpfPath,applyPath} in settings.json.
    '';
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
