{ config, lib, pkgs, inputs, outputs, ... }:
{
  home.persistence."/persist/home/${config.home.username}" = {
    removePrefixDirectory = false;
    allowOther = true;
    directories = [
      "nixos"
      ".ssh"
      ".cache"
      ".local/state"
      ".local/share"
      
      "Desktop"
      "Downloads"
      "Music"
      "Pictures"
      "Templates"
      "Documents"
      "Public"
      "Videos"
      "dev"

      ".pki"
      ".cargo"
      ".mozilla"
      ".config/Code"
    ];
    files = [
      ".bash_history"
      ".config/gh/hosts.yml"
      # ".config/Code"
    ];
  };
}
