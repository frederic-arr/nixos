{ config, lib, pkgs, inputs, outputs, ... }:
{
  imports = [ (inputs.impermanence + "/home-manager.nix") ];
  home.persistence."/persist/home/${config.home.username}" = {
    removePrefixDirectory = true;
    allowOther = true;
    directories = [ ".config/gh" ];
    files = [ ".bash_history" ];
  };
}
