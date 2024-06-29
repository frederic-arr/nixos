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


      ".mozilla/firefox/default/storage"
    ];
    files = [
      ".bash_history"
      ".config/gh/hosts.yml"

      ".mozilla/firefox/default/places.sqlite"
      ".mozilla/firefox/default/favicons.sqlite"
      ".mozilla/firefox/default/permissions.sqlite "
      ".mozilla/firefox/default/content-prefs.sqlite"
      ".mozilla/firefox/default/cookies.sqlite"
      ".mozilla/firefox/default/webappsstore.sqlite"
      ".mozilla/firefox/default/chromeappsstore.sqlite"
      ".mozilla/firefox/default/cert9.db"
      ".mozilla/firefox/default/pkcs11.txt"
      ".mozilla/firefox/default/sessionstore.jsonlz4"
      ".mozilla/firefox/default/xulstore.json"
      ".mozilla/firefox/default/storage-sync-v2.sqlite"
      # ".config/Code"
    ];
  };
}
