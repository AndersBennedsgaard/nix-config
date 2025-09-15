{
  description = "Anders's Nix Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixos-wsl,
    nixos-hardware,
    home-manager,
    ...
  }: let
    vars = import ./config/vars.nix {inherit (nixpkgs) lib;};

    # Helper for home-manager module
    mkHomeManagerModule = {config, ...}: {
      home-manager = {
        useUserPackages = true;
        backupFileExtension = "backup";
        users.${vars.user.name} = {};
      };
    };
  in {
    nixosConfigurations = {
      wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs vars;
          outputs = self;
        };
        modules = [
          nixos-wsl.nixosModules.default
          ./hosts/wsl
          home-manager.nixosModules.home-manager
          mkHomeManagerModule
        ];
      };
    };
  };
}
