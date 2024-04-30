# NixOs
## Quickstart
```bash
$ cd /tmp
$ curl -L https://github.com/frederic-arr/nixos/archive/refs/main.zip -o nixos-main.zip
$ unzip nixos-main.zip
$ source /tmp/nixos-main/setup.sh
$ nixos-install -j 100 --cores 8 --root /mnt --flake /mnt/etc/nixos#default
```
