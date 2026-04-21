host := `hostname`

deploy:
    NIXPKGS_ALLOW_UNFREE=1 nh os switch --no-nom --log-format bar-with-logs . -H {{host}} -- --impure

alias build := deploy

diff:
    NIXPKGS_ALLOW_UNFREE=1 nix build .#nixosConfigurations.{{host}}.config.system.build.toplevel --impure --out-link /tmp/nixos-result
    nvd diff /run/current-system /tmp/nixos-result

update:
    nix flake update

upgrade: && deploy
    nix flake update

update-pkgs:
    for p in pkgs/*/; do \
      name=$(basename "$p"); \
      echo "==> $name"; \
      if [ -x "$p/update.sh" ]; then \
        "$p/update.sh"; \
      else \
        nix run nixpkgs#nix-update -- --flake "$name" \
          || nix run nixpkgs#nix-update -- --flake --version=branch "$name" \
          || true; \
      fi; \
    done
