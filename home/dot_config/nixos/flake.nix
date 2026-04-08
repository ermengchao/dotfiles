{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    {
      nixosConfigurations = {
        minisforum = nixpkgs.lib.nixosSystem {
          modules = [
            ./hosts/minisforum
            ./users/chao/nixos.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.chao = ./users/chao/home.nix;

              # Optionally, use home-manager.extraSpecialArgs to pass
              # arguments to home.nix
            }
          ];
        };

        ec2-nixos = nixpkgs.lib.nixosSystem {
          modules = [
            ./hosts/ec2-nixos
            ./users/chao/nixos.nix
          ];
        };
      };
    };
}
