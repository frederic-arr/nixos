{ pkgs, inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.impermanence.nixosModules.impermanence
    ./impermanence.nix
    ./locale.nix
    ./nix.nix
  ];

  environment.systemPackages = [
    pkgs.git
    pkgs.gh
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  hardware.enableAllFirmware = true;
}
