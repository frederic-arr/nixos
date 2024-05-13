{ pkgs, inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.impermanence.nixosModules.impermanence
    inputs.home-manager.nixosModules.home-manager
    ./impermanence.nix
    ./locale.nix
    ./nix.nix
    ./desktop.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  hardware.enableAllFirmware = true;
}
