{ config, pkgs, ... }:
{
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;
    desktopManager.gnome = {
      enable = true;
      extraGSettingsOverrides = ''
        [org.gnome.mutter]
        experimental-features=['scale-monitor-framebuffer']
      '';

      extraGSettingsOverridePackages = [
        pkgs.gnome.mutter
      ];
    };

    excludePackages = with pkgs; [
      gnome-tour
      # xterm
    ];
  };

  # Remove default gnome applications
  services.gnome.core-utilities.enable = false;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.systemPackages = [
    pkgs.gnome-console
  ];
}
