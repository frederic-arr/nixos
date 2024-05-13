{ pkgs, lib, config, ... }:
{
  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    userSettings = builtins.fromJSON (builtins.readFile ./vscode/settings.json);
  };
}
