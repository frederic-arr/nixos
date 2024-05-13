{ config, pkgs, ... }:
{
  services.xserver = {
    enable = true;
    exportConfiguration = true;
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;
    desktopManager.gnome = {
      enable = true;
      extraGSettingsOverrides = ''
        [org.gnome.mutter]
        experimental-features=['scale-monitor-framebuffer']

        [org.gnome.desktop.peripherals.touchpad]
        click-method = 'default'
        tap-to-click = true
      '';

      extraGSettingsOverridePackages = [
        pkgs.gnome.mutter
      ];
    };

    libinput.enable = true;
    libinput.touchpad = {
      naturalScrolling = true;
    };
  };

  # Remove default gnome applications
  services.gnome.core-utilities.enable = false;
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    xterm
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.systemPackages = with pkgs; [
    gnome-console
    gnome.dconf-editor
  ];
}
