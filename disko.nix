{
  device ? throw "Set this to your disk device (e.g. /dev/nvme0n1)",
  swapSize ? throw "Set this to the amount of RAM you have (e.g. 16G)",
  ...
}:
{
  disko.devices = {
    disk.main = {
      device = device;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            type = "EF00";
            size = "100M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "crypted";
              settings.allowDiscards = true;
              content = {
                type = "lvm_pv";
                vg = "rvg";
              };
            };
          };
        };
      };
    };
    lvm_vg.rvg  = {
      type = "lvm_vg";
      lvs = {
        swap = {
          size = swapSize;
          content = {
            type = "swap";
            resumeDevice = true;
          };
        };
        root = {
          size = "100%FREE";
          content = {
            type = "zfs";
            pool = "rpool";
          };
        };
      };
    };
    zpool.rpool = {
      type = "zpool";
      mountpoint = "/";
      rootFsOptions = {
        acltype = "posixacl";
        canmount = "off";
        dnodesize = "auto";
        normalization = "formD";
        relatime = "on";
        xattr = "sa";
        mountpoint = "none";
      };
      options = {
        ashift = "12";
        autotrim = "on";
      };
      datasets = {
        "local/root" = {
          type = "zfs_fs";
          mountpoint = "/";
          postCreateHook = "zfs snapshot rpool/local/root@blank";
        };
        "local/nix" = {
          type = "zfs_fs";
          mountpoint = "/nix";
        };
        "safe/persist" = {
          type = "zfs_fs";
          mountpoint = "/persist";
        };
      };
    };
  };
}
