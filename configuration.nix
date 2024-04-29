{ pkgs, lib, inputs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ./host.nix
    ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;

  boot.loader.grub.zfsSupport = true;
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r rpool/local/root@blank
  '';
  boot.kernelParams = [ "elevator=none" ];

  users.users."user" = {
    isNormalUser = true;
    initialPassword = "user";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  fileSystems."/persist".neededForBoot = true;
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  system.stateVersion = "23.11";
}
