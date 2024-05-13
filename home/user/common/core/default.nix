{ config, lib, pkgs, inputs, outputs, ... }:
{
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
    ./git.nix
    ./impermanence.nix
  ];

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

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
