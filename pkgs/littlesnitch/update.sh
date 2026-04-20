#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq gnused
set -euo pipefail

cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

latest=$(curl -fsSL 'https://obdev.at/products/littlesnitch-linux/download.html' \
  | grep -oE 'littlesnitch-[0-9][0-9.-]+-x86_64\.pkg\.tar\.zst' \
  | sed -E 's/^littlesnitch-(.+)-x86_64\.pkg\.tar\.zst$/\1/' \
  | sort -V \
  | tail -n1)
current=$(sed -nE 's/^\s*version = "([^"]+)";.*/\1/p' package.nix | head -n1)

if [ -z "$latest" ]; then
  echo "littlesnitch: failed to parse version from download page" >&2
  exit 1
fi

if [ "$latest" = "$current" ]; then
  echo "littlesnitch: already $latest"
  exit 0
fi

echo "littlesnitch: $current -> $latest"

url="https://obdev.at/downloads/littlesnitch-linux/littlesnitch-${latest}-x86_64.pkg.tar.zst"
hash=$(nix store prefetch-file --json --hash-type sha256 "$url" | jq -r .hash)

sed -i -E "s|version = \"${current}\";|version = \"${latest}\";|" package.nix
sed -i -E "s|hash = \"[^\"]+\";|hash = \"${hash}\";|" package.nix
