#!/usr/bin/env bash
exec nix run nixpkgs#nix-update -- --flake --version=branch gitoverit
