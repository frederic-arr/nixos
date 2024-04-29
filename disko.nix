{
  disko.devices = {
    disk.main = {
      device = "/dev/nvme0n1";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            type = "EF00";
            size = "100MiB";
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
                type = "zfs";
                pool = "zroot";
              }
            };
          };
        };
      };
    };
    zpool.zroot = {
      type = "zpool";
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
        "rpool/local/root" = {
          type = "zfs_fs";
          mountpoint = "/";
          postCreateHook = "zfs snapshot rpool/local/root@blank";
        };
        "rpool/local/nix" = {
          type = "zfs_fs";
          mountpoint = "/nix";
        };
        "rpool/safe/persist" = {
          type = "zfs_fs";
          mountpoint = "/persist";
        };
      };
    };
  };
}
