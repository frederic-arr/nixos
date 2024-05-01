{
  description = "Nixos config flake";
     
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
  let
    inherit (self) outputs;
    inherit (nixpkgs) lib;
    configLib = import ./libs { inherit lib; };
    specialArgs = { inherit inputs outputs configLib nixpkgs; };
  in
  {
    nixosConfigurations = {
      laptop = lib.nixosSystem {
        inherit specialArgs;
        modules = [
          home-manager.nixosModules.home-manager{
            home-manager.extraSpecialArgs = specialArgs;
          }
          ./hosts/laptop
        ];
      };
    };
  };
}
