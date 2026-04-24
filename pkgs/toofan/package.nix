{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "toofan";
  version = "2.1.0";  # or a tag if there is one

  src = fetchFromGitHub {
    owner = "vyrx-dev";
    repo = "toofan";
    rev = "master";  # pin to a commit sha for reproducibility
    hash = "sha256-oez6iev1sxel4dy4kAqRdhZstpttC1VMEysoP9QrcEc=";
  };

  vendorHash = "sha256-YSjJ8NOL97hXZLnfGYIjoKmARv+gWOsv+5qkl9konnA=";

  meta = {
    description = "Minimal, lightning-fast typing TUI";
    homepage = "https://github.com/vyrx-dev/toofan";
    mainProgram = "toofan";
  };
}

