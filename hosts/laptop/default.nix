{ inputs, configLib, ... }:
{
  imports = [
    (import (configLib.relativeToRoot "libs/disko.nix") { device = "/dev/nvme0n1"; swapSize = "16G"; })
    ./hardware-configuration.nix
    (configLib.relativeToRoot "hosts/common/core")
    (configLib.relativeToRoot "hosts/common/users/user")
  ];

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 5;
  };
  networking.hostName = "laptop";
  networking.hostId = "8a99137d"; # Required for ZFS

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
