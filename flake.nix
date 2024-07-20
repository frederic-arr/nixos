{
  description = "Nixos config flake";
     
  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    impermanence.url = "github:nix-community/impermanence";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs-stable, nixpkgs-unstable, impermanence, home-manager, fenix, ... } @ inputs:
  let
    system = "x86_64-linux";
    inherit (self) outputs;
    inherit (nixpkgs-stable) lib;
    stable = import nixpkgs-stable { inherit system; config.allowUnfree = true; };
    unstable = import nixpkgs-unstable { inherit system; config.allowUnfree = true; };
    configLib = import ./libs { inherit lib; };
    specialArgs = {
      inherit
      inputs
      outputs
      configLib
      nixpkgs-stable
      nixpkgs-unstable
      stable
      unstable
      system
      fenix;
    };
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
