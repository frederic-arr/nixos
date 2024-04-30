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
sudo rm -rf /tmp/nixos-main /tmp/nixos-main.zip
sudo curl -L https://github.com/frederic-arr/nixos/archive/refs/heads/main.zip -o /tmp/nixos-main.zip
sudo unzip /tmp/nixos-main.zip -d /tmp

echo "Setting up partitions for $DEVICE + $SWAP SWAP"
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/nixos-main/disko.nix --arg device "\"$DEVICE\"" --arg swapSize "\"$SWAP\""

echo "Configuring NixOs"
sudo mkdir -p /mnt/etc/nixos/
sudo cp -a /tmp/nixos-main/. /mnt/etc/nixos/
sudo cp /etc/machine-id /mnt/etc/machine-id
sudo nixos-generate-config --no-filesystems --show-hardware-config > /mnt/etc/nixos/hardware-configuration.nix

echo "Done"
