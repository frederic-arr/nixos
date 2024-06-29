{ inputs, lib, configLib, ... }:
{
  imports = [
    (import (configLib.relativeToRoot "libs/disko.nix") { device = "/dev/nvme0n1"; swapSize = "16G"; })
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.common-pc-laptop-acpi_call
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-yoga
    (configLib.relativeToRoot "hosts/common/core")
    ./impermanence.nix
    (configLib.relativeToRoot "hosts/common/users/user")
  ];

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 5;
  };
  
  boot.kernelParams = [ "pmouse.synaptics_intertouch=0" ];
  console.earlySetup = true;
  services.xserver.dpi = 210;
  services.throttled.enable = true;


  networking.hostName = "laptop";
  networking.hostId = "8a99137d"; # Required for ZFS

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
