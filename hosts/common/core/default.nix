{ inputs, outputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.impermanence.nixosModules.impermanence
    ./impermanence.nix
    ./locale.nix
    ./nix.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  hardware.enableAllFirmware = true;
}
