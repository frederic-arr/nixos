{ pkgs, lib, config, ... }:
{
  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = true;
    enableUpdateCheck = true;
  };
}
