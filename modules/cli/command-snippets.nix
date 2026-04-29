{
  flake.modules.homeManager.base = { config, lib, pkgs, ... }:
    let
      localPath = "${config.home.homeDirectory}/Documents/HomeLab/command-snippets";
      command-snippets =
        if builtins.pathExists localPath
        then pkgs.command-snippets.overrideAttrs (_: {
          src = lib.cleanSource (/. + localPath);
        })
        else pkgs.command-snippets;
    in {
      home.packages = [ command-snippets ];

      home.file.".config/cs" = {
        source = ../../config/cs;
        recursive = true;
      };

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
