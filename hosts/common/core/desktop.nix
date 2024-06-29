{ config, pkgs, ... }:
{
  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
  };

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
        speed = 0.3
      '';

      extraGSettingsOverridePackages = [
        pkgs.gnome.mutter
      ];
    };

    excludePackages = with pkgs; [
      xterm
    ];
  };

  # Remove default gnome applications
  services.gnome.core-utilities.enable = false;
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.systemPackages = with pkgs; [
    gnome-console
    gnome.dconf-editor
  ];
}
