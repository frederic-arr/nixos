echo "Args($#): $@"

if [[ $# != "2" ]]; then
    echo "Usage: $0 [device] [swapSize]"
    echo "Example: $0 /dev/nvme0n1 16G"
    exit 1
fi

DEVICE=$1
SWAP=$2

echo "Downloading repository"
sudo su root
rm -rf /tmp/nixos-main /tmp/nixos-main.zip
curl -L https://github.com/frederic-arr/nixos/archive/refs/heads/main.zip -o /tmp/nixos-main.zip
unzip /tmp/nixos-main.zip -d /tmp

echo "Setting up partitions for $DEVICE + $SWAP SWAP"
nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/nixos-main/disko.nix --arg device "\"$DEVICE\"" --arg swapSize "\"$SWAP\""

echo "Configuring NixOs"
mkdir -p /mnt/etc/nixos/
cp -a /tmp/nixos-main/. /mnt/etc/nixos/
cp /etc/machine-id /mnt/etc/machine-id
nixos-generate-config --no-filesystems --show-hardware-config > /mnt/etc/nixos/hardware-configuration.nix

echo "Done"
