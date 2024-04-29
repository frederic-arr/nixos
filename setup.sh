#!/bin/bash
set -euo pipefail

nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/nixos-main/disko.nix
mkdir -p /mnt/etc/nixos/
cp -a /tmp/nixos-config/ /mnt/etc/nixos/
nixos-generate-config --no-filesystems --show-hardware-config > /mnt/etc/nixos/hardware-configuration.nix
