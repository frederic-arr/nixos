{ inputs, outputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
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
