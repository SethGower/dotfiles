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
    nixpkgs-unstable,
    sops-nix,
    nixos-hardware,
    home-manager,
    ...
  } @ attrs: let
    system = "x86_64-linux"; # Adjust for your system
    overlays = [
      (final: prev: {
        unstable = pkgsUnstable;
        vrl-lsp = prev.callPackage ./nix/packages/vrl-lsp.nix {};
      })
    ];

    unfree_whitelist = [
      "discord"
      "castlabs-electron"
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
      "nvidia-x11"
      "nvidia-settings"
      "chromium"
      "cuda-merged"
      "cuda_cuobjdump"
      "cuda_gdb"
      "cuda_nvcc"
      "cuda_nvprune"
      "cuda_nvdisasm"
      "cuda_cccl"
      "cuda_cudart"
      "cuda_cupti"
      "cuda_cuxxfilt"
      "cuda_nvml_dev"
      "cuda_nvrtc"
      "cuda_nvtx"
      "cuda_profiler_api"
      "cuda_sanitizer_api"
      "libcublas"
      "libcufft"
      "libcurand"
      "libcusolver"
      "libnvjitlink"
      "libcusparse"
      "libnpp"
    ];
    insecure_packages = [""];

    pkgsUnstable = import nixpkgs-unstable {
      inherit system;
      config = {
        allowUnfree = false;
        allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) unfree_whitelist;
        permittedInsecurePackages = insecure_packages;
      };
    };
    pkgs = import nixpkgs {
      inherit system overlays;
      config = {
        allowUnfree = false;
        allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) unfree_whitelist;
        permittedInsecurePackages = insecure_packages;
      };
    };
    # pkgs = nixpkgs.legacyPackages.${system};
  in {
    # Framework 13 Laptop
    nixosConfigurations.hammond = nixpkgs.lib.nixosSystem {
      inherit system pkgs;
      specialArgs = attrs;
      modules = [
        ./nix/hosts/hammond
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
    homeConfigurations."sgower" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [./users/sgower/home.nix];
    };
    devShells."x86_64-linux".default = pkgs.mkShell {
      packages = with pkgs; [
        sops
      ];
    };
  };
}
