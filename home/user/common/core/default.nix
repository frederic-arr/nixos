{ config, lib, pkgs, inputs, outputs, ... }:
{
  imports = [
    ./git.nix
    ./impermanence.nix
  ];

  programs.home-manager.enable = true;
  home = {
    username = "user";
    homeDirectory = "/home/${config.home.username}";
    packages = builtins.attrValues {
      inherit (pkgs);
    };
    stateVersion = "23.11";
  };
}
