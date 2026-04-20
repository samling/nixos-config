#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq
set -euo pipefail

cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

latest=$(curl -fsSL 'https://api.github.com/repos/gravitational/teleport/releases?per_page=100' \
  | jq -r '.[] | select(.prerelease == false and .draft == false) | .tag_name' \
  | sed 's/^v//' \
  | sort -V \
  | tail -n1)
current=$(sed -nE 's/^\s*version = "([^"]+)";.*/\1/p' package.nix | head -n1)

if [ "$latest" = "$current" ]; then
  echo "teleport-bin: already $latest"
  exit 0
fi

echo "teleport-bin: $current -> $latest"

url="https://cdn.teleport.dev/teleport-v${latest}-linux-amd64-bin.tar.gz"
hash=$(nix store prefetch-file --json --hash-type sha256 "$url" | jq -r .hash)

sed -i -E "s|version = \"${current}\";|version = \"${latest}\";|" package.nix
sed -i -E "s|hash = \"[^\"]+\";|hash = \"${hash}\";|" package.nix
