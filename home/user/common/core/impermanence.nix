{ config, lib, pkgs, inputs, outputs, ... }:
{
  home.persistence."/persist/home/${config.home.username}" = {
    removePrefixDirectory = false;
    allowOther = true;
    directories = [
      "nixos"
      ".ssh"
      ".local/share/keyrings"
    ];
    files = [
      ".bash_history"
      ".config/gh/hosts.yml"
      # ".config/Code"
    ];
  };
}
