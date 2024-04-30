#!/bin/bash
set -euo pipefail

if [[ $# != "2" ]]; then
    echo "Usage: $0 [device] [swapSize]"
    echo "Example: $0 /dev/nvme0n1 16G"
    exit 1
fi

DEVICE=$1
SWAP=$2

echo "Downloading repository"
rm -rf /tmp/nixos-main /tmp/nixos-main.zip
curl -L https://github.com/frederic-arr/nixos/archive/refs/heads/main.zip -o /tmp/nixos-main.zip
unzip /tmp/nixos-main.zip -d /tmp

echo "Setting up partitions for $DEVICE + $SWAP SWAP"
wipefs -fa $DEVICE
nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/nixos-main/disko.nix --arg device "\"$DEVICE\"" --arg swapSize "\"$SWAP\""

echo "Configuring NixOs"
mkdir -p /mnt/etc/nixos/
cp -ra /tmp/nixos-main/. /mnt/etc/nixos/
nixos-generate-config --no-filesystems --show-hardware-config > /mnt/etc/nixos/hardware-configuration.nix

echo "Installing NixOs"
mkdir -p /mnt/persist/etc/nixos
cp -ra /mnt/etc/nixos/. /mnt/persist/etc/nixos/
nixos-install -j 100 --cores 8 --root /mnt --flake /mnt/etc/nixos#default
reboot now
