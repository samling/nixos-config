host := `hostname`

boot:
    NIXPKGS_ALLOW_UNFREE=1 nh os boot --no-nom --show-activation-logs --log-format bar-with-logs . -H {{host}} -- --impure

deploy:
    NIXPKGS_ALLOW_UNFREE=1 nh os switch --no-nom --show-activation-logs --log-format bar-with-logs . -H {{host}} -- --impure

alias apply := deploy

diff:
    NIXPKGS_ALLOW_UNFREE=1 nix build .#nixosConfigurations.{{host}}.config.system.build.toplevel --impure --out-link /tmp/nixos-result
    nvd diff /run/current-system /tmp/nixos-result
    rm -f result

update:
    nix flake update

# Non-shebang to avoid WSLg's noexec /run/user/$UID overlay, where just writes
# shebang recipes and fails to execve them.
upgrade:
    @bash -c '\
      set -euo pipefail; \
      [[ -n "${GITHUB_TOKEN:-}" ]] && export NIX_CONFIG="access-tokens = github.com=$GITHUB_TOKEN"; \
      just bump-pkgs; \
      just update; \
      git --no-pager diff; \
      read -rp "Continue with switch? [y/N] " ans; \
      [[ "$ans" == [yY]* ]] || exit 0; \
      just deploy; \
      git add flake.lock pkgs/; \
      git commit -m "Upgrade flake inputs and packages" || true \
    '

bump-pkgs:
    blacklist="pkgs/.skip-update"; \
    for p in pkgs/*/; do \
      name=$(basename "$p"); \
      if [ -f "$blacklist" ] && grep -qxF "$name" "$blacklist"; then \
        echo "==> $name (skipped: in $blacklist)"; \
        continue; \
      fi; \
      echo "==> $name"; \
      if [ -x "$p/update.sh" ]; then \
        "$p/update.sh"; \
      else \
        nix run nixpkgs#nix-update -- --flake "$name" \
          || nix run nixpkgs#nix-update -- --flake --version=branch "$name" \
          || true; \
      fi; \
    done

clean:
  nh clean all -k10
