host := `hostname`

boot:
    NIXPKGS_ALLOW_UNFREE=1 nh os boot --no-nom --show-activation-logs --log-format bar-with-logs . -H {{host}} -- --impure

apply:
    NIXPKGS_ALLOW_UNFREE=1 nh os switch --no-nom --show-activation-logs --log-format bar-with-logs . -H {{host}} -- --impure
    @just overrides

# Surface any "TEMP-OVERRIDE:" markers left in the tree so we remember to remove
# them once upstream catches up. Add the marker in a comment next to the
# override (overlay, pin, patch, etc.); a brief description after the colon is
# echoed verbatim. The Justfile itself is excluded so this recipe doesn't match
# its own grep pattern.
overrides:
    @hits=$(git grep -n --untracked "TEMP-OVERRIDE:" -- ':!Justfile' 2>/dev/null || true); \
    if [ -n "$hits" ]; then \
      printf "\n=== Active TEMP-OVERRIDEs ===\n%s\n" "$hits"; \
    fi

# Show the most recent home-manager activation logs from this boot.
# Use when `just apply` fails and nh hides the real error.
log user=`whoami`:
    journalctl -xeu home-manager-{{user}}.service -b --no-pager

diff:
    NIXPKGS_ALLOW_UNFREE=1 nix build .#nixosConfigurations.{{host}}.config.system.build.toplevel --impure --out-link /tmp/nixos-result
    nvd diff /run/current-system /tmp/nixos-result
    rm -f result

update-lock:
    nix flake update

# Non-shebang to avoid WSLg's noexec /run/user/$UID overlay, where just writes
# shebang recipes and fails to execve them.
update:
    @bash -c '\
      set -euo pipefail; \
      [[ -n "${GITHUB_TOKEN:-}" ]] && export NIX_CONFIG="access-tokens = github.com=$GITHUB_TOKEN"; \
      git diff --quiet -- pkgs/ && git diff --cached --quiet -- pkgs/ || { echo "Uncommitted changes in pkgs directory; commit or stash those first." >&2; exit 1; }; \
      just bump-pkgs; \
      if git diff --quiet pkgs/; then \
        echo "Nothing new to bump — applying current flake state."; \
        just apply; \
        exit 0; \
      fi; \
      git --no-pager diff pkgs/; \
      read -rp "Continue with switch? [y/N] " ans; \
      if [[ "$ans" != [yY]* ]]; then \
        git restore pkgs/; \
        echo "Reverted."; exit 0; \
      fi; \
      just apply; \
      git add pkgs/; \
      git commit -m "Upgrade packages" \
    '

upgrade:
    @bash -c '\
      set -euo pipefail; \
      [[ -n "${GITHUB_TOKEN:-}" ]] && export NIX_CONFIG="access-tokens = github.com=$GITHUB_TOKEN"; \
      git diff --quiet -- flake.lock pkgs/ && git diff --cached --quiet -- flake.lock pkgs/ || { echo "Uncommitted changes in flake.lock or pkgs directory; commit or stash those first." >&2; exit 1; }; \
      just update-lock; \
      just bump-pkgs; \
      if git diff --quiet flake.lock pkgs/; then \
        echo "Nothing new to bump — applying current flake state."; \
        just apply; \
        exit 0; \
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
