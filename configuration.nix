{ pkgs, lib, inputs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ./host.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.grub.enable = true;
  # boot.loader.grub.device = "nodev";
  # boot.loader.grub.efiSupport = true;

  # boot.loader.grub.zfsSupport = true;
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
      "/etc/nixos"
      "/root/.config"
    ];
    files = [
      "/etc/machine-id"
      "/root/.bash_history"
      "/root/.gitconfig"
    ];
  };

  environment.systemPackages = [
    pkgs.git
    pkgs.gh
  ];
  systemd.services.save-root-snapshot = {
    description = "save a snapshot of the initial root tree";
    wantedBy = [ "sysinit.target" ];
    requires = [ "-.mount" ];
    after = [ "-.mount" ];
    serviceConfig.Type = "oneshot";
    serviceConfig.RemainAfterExit = true;
    serviceConfig.ExecStart = "\"/bin/bash -c 'zfs destroy -r rpool/local/root@boot || true && zfs snapshot rpool/local/root@boot'\"";
  };

  system.stateVersion = "23.11";
}
