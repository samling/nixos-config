host := `hostname`

boot:
    NIXPKGS_ALLOW_UNFREE=1 nh os boot --no-nom --show-activation-logs --log-format bar-with-logs . -H {{host}} -- --impure

apply:
    NIXPKGS_ALLOW_UNFREE=1 nh os switch --no-nom --show-activation-logs --log-format bar-with-logs . -H {{host}} -- --impure

# Show the most recent home-manager activation logs from this boot.
# Use when `just apply` fails and nh hides the real error.
log user=`whoami`:
    journalctl -xeu home-manager-{{user}}.service -b --no-pager

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
      [[ -z "$(git status --porcelain)" ]] || { echo "Working tree dirty — commit or stash first." >&2; exit 1; }; \
      just update; \
      just bump-pkgs; \
      if git diff --quiet flake.lock pkgs/; then \
        echo "Nothing to upgrade."; exit 0; \
      fi; \
      git --no-pager diff flake.lock pkgs/; \
      read -rp "Continue with switch? [y/N] " ans; \
      if [[ "$ans" != [yY]* ]]; then \
        git restore flake.lock pkgs/; \
        echo "Reverted."; exit 0; \
      fi; \
      just apply; \
      git add flake.lock pkgs/; \
      git commit -m "Upgrade flake inputs and packages" \
    '

# Per-package opt-ins:
#   pkgs/.skip-update           one package name per line; skipped entirely
#   pkgs/<name>/.track-branch   sentinel file → use --version=branch (else tags)
# Failures are collected and printed at the end; recipe exits non-zero if any
# package failed, so `upgrade` halts before committing a partial state.
bump-pkgs:
    @set -u; \
    blacklist="pkgs/.skip-update"; \
    failed=""; \
    for p in pkgs/*/; do \
      name=$(basename "$p"); \
      if [ -f "$blacklist" ] && grep -qxF "$name" "$blacklist"; then \
        echo "==> $name (skipped)"; \
        continue; \
      fi; \
      echo "==> $name"; \
      if [ -x "$p/update.sh" ]; then \
        "$p/update.sh" || failed="$failed $name"; \
      elif [ -f "$p/.track-branch" ]; then \
        nix run nixpkgs#nix-update -- --flake --version=branch "$name" || failed="$failed $name"; \
      else \
        nix run nixpkgs#nix-update -- --flake "$name" || failed="$failed $name"; \
      fi; \
    done; \
    if [ -n "$failed" ]; then \
      printf "\nFailed to update:%s\n" "$failed" >&2; \
      exit 1; \
    fi

clean:
  nh clean all -k 20 --keep-since 14d --nogc

gc:
  nh clean all -k 20 --keep-since 14d
