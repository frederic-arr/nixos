{ pkgs, lib, config, configLib, inputs, ... }:
{
  imports = [
    (import (configLib.relativeToRoot "libs/home-impermanence.nix") { user = "user"; })
  ];

  users.users."user" = {
    isNormalUser = true;
    initialPassword = "user";
    extraGroups = [ "wheel" "networkmanager" ];
    packages = [ pkgs.home-manager ];
    shell = pkgs.zsh;
  };

  home-manager.backupFileExtension = "backup";
  home-manager.users."user" = import (configLib.relativeToRoot "home/user/${config.networking.hostName}.nix");
}
