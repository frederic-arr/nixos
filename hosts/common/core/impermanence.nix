{ pkgs, lib, inputs, ... }:
with lib;
let
  cfg = config.state;
    save-boot-root = pkgs.writers.writeDashBin "save-boot-root"
    ''
      export PATH=${with pkgs; makeBinPath [ zfs ]}:$PATH
      zfs destroy -r rpool/local/root@boot || true && zfs snapshot rpool/local/root@boot
    '';

    diff-boot-root = pkgs.writers.writeDashBin "diff-boot-root"
    ''
      export PATH=${with pkgs; makeBinPath [ zfs ]}:$PATH
      zfs diff -H rpool/local/root@boot | awk '! /(^|\/)\.?(tmp|temp|cache)(\/|$)/'
    '';

    save-post-login-root = pkgs.writers.writeDashBin "save-post-login-root"
    ''
      export PATH=${with pkgs; makeBinPath [ zfs ]}:$PATH
      zfs destroy -r rpool/local/root@post-login || true && zfs snapshot rpool/local/root@post-login
    '';

    diff-post-login-root = pkgs.writers.writeDashBin "diff-post-login-root"
    ''
      export PATH=${with pkgs; makeBinPath [ zfs ]}:$PATH
      zfs diff -H rpool/local/root@post-login | awk '! /(^|\/)\.?(tmp|temp|cache)(\/|$)/'
    '';
in
{
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r rpool/local/root@blank
  '';
  boot.kernelParams = [ "elevator=none" ];

  fileSystems."/persist".neededForBoot = true;
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/bluetooth"
      "/etc/NetworkManager/system-connections"
      "/etc/sysfs"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  programs.fuse.userAllowOther = true;
  environment.systemPackages = [
    diff-boot-root
    save-post-login-root
    diff-post-login-root
  ];

  systemd.services.save-boot-root-snapshot = {
    description = "save a snapshot of the boot root tree";
    wantedBy = [ "sysinit.target" ];
    requires = [ "-.mount" ];
    after = [ "-.mount" ];
    serviceConfig.Type = "oneshot";
    serviceConfig.RemainAfterExit = true;
    serviceConfig.ExecStart = ''${save-boot-root}/bin/save-boot-root'';
  };
}
