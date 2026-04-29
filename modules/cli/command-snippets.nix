{
  flake.modules.homeManager.base = { config, lib, pkgs, ... }:
    let
      localPath = "${config.home.homeDirectory}/Documents/HomeLab/command-snippets";
      command-snippets = pkgs.callPackage ../../pkgs/command-snippets/package.nix {
        src = lib.cleanSource (/. + localPath);
      };
    in {
      home.packages = [ command-snippets ];

      home.file.".config/cs" = {
        source = ../../config/cs;
        recursive = true;
      };

      # Bootstrap: ensure the local clone exists so future activations build
      # from it. The first activation on a fresh machine still needs to be
      # preceded by a manual clone (build runs before activation).
      home.activation.cloneCommandSnippets =
        lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          if [ ! -d "${localPath}/.git" ]; then
            run mkdir -p "$(dirname "${localPath}")"
            run ${pkgs.git}/bin/git clone \
              https://github.com/samling/command-snippets.git \
              "${localPath}"
          fi
        '';
    };
}
