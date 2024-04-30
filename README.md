# NixOs
## Quickstart
```bash
$ curl https://raw.githubusercontent.com/frederic-arr/nixos/main/scripts/setup.sh | bash -s /dev/nvme0n1 16G
$ nixos-install -j 100 --cores 8 --root /mnt --flake /mnt/etc/nixos#default
```
