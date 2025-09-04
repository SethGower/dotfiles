{
  description = "NixOS and home-manager configuration Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    sops-nix,
    nixos-hardware,
    home-manager,
    ...
  } @ attrs: let
    system = "x86_64-linux"; # Adjust for your system
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    # Framework 13 Laptop
    nixosConfigurations.hammond = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = attrs;
      modules = [
        ./nix/configuration.nix
        nixos-hardware.nixosModules.framework-11th-gen-intel
        sops-nix.nixosModules.sops
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.sgower = import ./users/sgower/home.nix;
        }
      ];
    };
    homeConfigurations."seth.gower_cn" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [./users/seth.gower_cn/home.nix];
    };
  };
}
