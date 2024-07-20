{ config, lib, pkgs, inputs, outputs, ... }:
{
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
    ./git.nix
    ./code.nix
    ./web.nix
    ./zsh.nix
    ./impermanence.nix
  ];

  xdg.enable = true;

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    settings."org/gnome/desktop/wm/keybindings".switch-to-workspace-up = [];
    settings."org/gnome/desktop/wm/keybindings".switch-to-workspace-down = [];
    settings."org/gnome/desktop/wm/keybindings".switch-applications = [];
    settings."org/gnome/desktop/wm/keybindings".switch-windows = ["<Alt>Tab"];
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (_: true);

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
