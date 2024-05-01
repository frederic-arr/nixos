{ config, lib, pkgs, outputs, ... }:
{
  home.persistence."/persist/home/${config.home.username}" = {
    directories = [ ".config/gh" ];
    files = [ ".bash_history" ];
  };
}
