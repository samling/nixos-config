{ buildGoModule, src }:

buildGoModule {
  pname = "command-snippets";
  version = "0.1.0-local";

  inherit src;

  vendorHash = "sha256-o1zT1XczVYtFW51lT3u+E0kCRdwQ8BibPGh4Rdo5BIk=";

  subPackages = [ "cmd/cs" ];

  meta = {
    description = "Fuzzy-searchable command snippet manager";
    homepage = "https://github.com/samling/command-snippets";
    mainProgram = "cs";
  };
}
