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

      # See https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  hardware.enableAllFirmware = true;
}
