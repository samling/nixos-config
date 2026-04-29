#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq
set -euo pipefail

cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

auth=()
[[ -n "${GITHUB_TOKEN:-}" ]] && auth=(-H "Authorization: Bearer ${GITHUB_TOKEN}")

latest=$(curl -fsSL "${auth[@]}" 'https://api.github.com/repos/Infisical/cli/releases/latest' \
  | jq -r '.tag_name' \
  | sed 's/^v//')
current=$(sed -nE 's/^\s*version = "([^"]+)";.*/\1/p' package.nix | head -n1)

if [ "$latest" = "$current" ]; then
  echo "infisical-bin: already $latest"
  exit 0
fi

echo "infisical-bin: $current -> $latest"

url="https://github.com/Infisical/cli/releases/download/v${latest}/cli_${latest}_linux_amd64.tar.gz"
hash=$(nix store prefetch-file --json --hash-type sha256 "$url" | jq -r .hash)

sed -i -E "s|version = \"${current}\";|version = \"${latest}\";|" package.nix
sed -i -E "s|hash = \"[^\"]+\";|hash = \"${hash}\";|" package.nix
