{ pkgs, lib, config, configLib, inputs, ... }:
{
  imports = [
    (import (configLib.relativeToRoot "libs/home-impermanence.nix") { user = "user"; })
  ];

  users.users."user" = {
    isNormalUser = true;
    initialPassword = "user";
    extraGroups = [ "wheel" ];
    packages = [ pkgs.home-manager ];
  };

  home-manager.users."user" = import (configLib.relativeToRoot "home/user/${config.networking.hostName}.nix");
}
