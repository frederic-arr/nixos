{ config, lib, pkgs, inputs, outputs, ... }:
{
  home.persistence."/persist/home/${config.home.username}" = {
    removePrefixDirectory = false;
    allowOther = true;
    directories = [ "nixos" ];
    files = [
      ".bash_history"
      ".config/gh/hosts.yml"
    ];
  };
}
