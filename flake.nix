{
  description = "Nixos config flake";
     
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = { self, nixpkgs, ... } @ inputs:
  let
    inherit (self) outputs;
    inherit (nixpkgs) lib;
    configLib = import ./lib { inherit lib; };
    specialArgs = { inherit inputs outputs configLib nixpkgs; };
  in
  {
    nixosConfigurations = {
      laptop = lib.nixosSystem {
        inherit specialArgs;
        modules = [ ./hosts/laptop ];
      };
    };
  };
}
