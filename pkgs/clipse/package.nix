{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

# Local override of nixpkgs' clipse (currently 1.1.0) until
# https://github.com/NixOS/nixpkgs/pull/484504 lands. Drop this directory
# once unstable ships >= 1.2.1.
buildGoModule (finalAttrs: {
  pname = "clipse";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "savedra1";
    repo = "clipse";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iDMHEhYuxspBYG54WivnVj2GfMxAc5dcrjNxtAMhsck=";
  };

  vendorHash = "sha256-rq+2UhT/kAcYMdla+Z/11ofNv2n4FLvpVgHZDe0HqX4=";

  tags = [ "wayland" ];

  env.CGO_ENABLED = "0";

  meta = {
    description = "Useful clipboard manager TUI for Unix";
    homepage = "https://github.com/savedra1/clipse";
    license = lib.licenses.mit;
    mainProgram = "clipse";
  };
})
