{
  description = "Nixos config flake";
     
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, impermanence, home-manager, ... } @ inputs:
  let
    system = "x86_64-linux";
    inherit (self) outputs;
    inherit (nixpkgs) lib;
    unstable = import nixpkgs-unstable { inherit system; config.allowUnfree = true; };
    configLib = import ./libs { inherit lib; };
    specialArgs = { inherit inputs outputs configLib nixpkgs nixpkgs-unstable unstable; };
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
