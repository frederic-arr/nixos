{ config, lib, pkgs, inputs, outputs, ... }:
{
  imports = [
    specialArgs.inputs.impermanence.nixosModules.home-manager.impermanence
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
