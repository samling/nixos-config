{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "toofan";
  version = "2.2.0";  # or a tag if there is one

  src = fetchFromGitHub {
    owner = "vyrx-dev";
    repo = "toofan";
    rev = "master";  # pin to a commit sha for reproducibility
    hash = "sha256-pm3q6Fb/lUl49PsxQd7+0R9iFNQbDH05fn7O4pYAWi0=";
  };

  vendorHash = "sha256-YSjJ8NOL97hXZLnfGYIjoKmARv+gWOsv+5qkl9konnA=";

  meta = {
    description = "Minimal, lightning-fast typing TUI";
    homepage = "https://github.com/vyrx-dev/toofan";
    mainProgram = "toofan";
  };
}

