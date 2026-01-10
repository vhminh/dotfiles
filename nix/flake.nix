{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ibus-bamboo = {
      url = "github:BambooEngine/ibus-bamboo";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, nur, ibus-bamboo, ... }: {
    nixosConfigurations = {
      nixos-desktop = let
        username = "minh";
        fullname = "Minh Vu";
        email = "minhvh99@gmail.com";
        system = "x86_64-linux";
        specialArgs =  { inherit inputs; inherit username; inherit fullname; inherit email; inherit system; };
      in nixpkgs.lib.nixosSystem {
        inherit system;
        inherit specialArgs;
        modules = [
          ./hosts/home-desktop/configuration.nix

          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = inputs // specialArgs;
            home-manager.users.minh = import ./hosts/home-desktop/home.nix;
          }

          nur.modules.nixos.default
        ];
      };
    };
  };
}
