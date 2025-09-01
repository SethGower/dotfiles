{
  description = "NixOS Personal Computer Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = github:nix-community/home-manager;
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
    ...
  } @ attrs: {
    # Framework 13 Laptop
    nixosConfigurations.hammond = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        ./nix/configuration.nix
        # nixos-hardwarex.nixosModules.framework-11th-gen-intel
        sops-nix.nixosModules.sops
      ];
    };
  };
}
