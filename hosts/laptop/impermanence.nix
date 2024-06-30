{ pkgs, lib, inputs, ... }:
with lib;
let
  cfg = config.state;
    save-sysfs = pkgs.writers.writeDashBin "save-sysfs"
    ''
      cat /sys/class/backlight/intel_backlight/brightness > /etc/sysfs/brightness
    '';

    restore-sysfs = pkgs.writers.writeDashBin "restore-sysfs"
    ''
      cat /etc/sysfs/brightness > /sys/class/backlight/intel_backlight/brightness
    '';
in
{
  systemd.services.save-sysfs = {
    description = "save sysfs values";
    serviceConfig.Type = "oneshot";
    serviceConfig.RemainAfterExit = true;
    serviceConfig.ExecStart = ''${with pkgs; makeBinPath [ coreutils ]}/true'';
    serviceConfig.ExecStop = ''${save-sysfs}/bin/save-sysfs'';
    wantedBy = [ "multi-user.target" ];
  };

  systemd.services.restore-sysfs = {
    description = "restore sysfs values";
    wantedBy = [ "sysinit.target" ];
    requires = [ "-.mount" ];
    after = [ "-.mount" ];
    serviceConfig.Type = "oneshot";
    serviceConfig.RemainAfterExit = true;
    serviceConfig.ExecStart = ''${restore-sysfs}/bin/restore-sysfs'';
  };
}
