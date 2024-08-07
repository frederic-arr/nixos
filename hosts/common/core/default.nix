{ pkgs, inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.impermanence.nixosModules.impermanence
    inputs.home-manager.nixosModules.home-manager
    ./impermanence.nix
    ./locale.nix
    ./nix.nix
    ./audio.nix
    ./desktop.nix
    ./rust.nix
  ];

  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;

  programs.zsh.enable = true;
  environment.pathsToLink = [ "/share/zsh" ];
}
