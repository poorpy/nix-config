{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # neovim-nightly-overlay = {
    #   url = "github:nix-community/neovim-nightly-overlay";
    #   inputs.neovim-flake.url = "github:neovim/neovim?dir=contrib&rev=27fb62988e922c2739035f477f93cc052a4fee1e";
    # };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , darwin
    , nix-homebrew
    , homebrew-bundle
    , homebrew-core
    , homebrew-cask
    , ...
    }@inputs:
    let
      inherit (self) outputs;
      darwinSystems = [
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      linuxSystems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems);
    in
    {
      # Your custom packages
      # Acessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./pkgs { inherit pkgs; }
      );
      # Devshell for bootstrapping
      # Acessible through 'nix develop' or 'nix-shell' (legacy)
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./shell.nix { inherit pkgs; }
      );

      overlays = import ./overlays { inherit inputs; };
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      darwinConfigurations = nixpkgs.lib.genAttrs darwinSystems (system:
        darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit inputs outputs; };
          modules = [
            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                user = "bmarczyn";
                enable = true;
                taps = {
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-cask" = homebrew-cask;
                  "homebrew/homebrew-bundle" = homebrew-bundle;
                };
                mutableTaps = false;
                autoMigrate = true;
              };
            }
            ./hosts/darwin
          ];
        });

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };
        system = "x86_64-linux";
        modules = [
          ./hosts/laptop/default.nix
        ];
      };

      nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };
        system = "x86_64-linux";
        modules = [
          ./hosts/desktop/default.nix
        ];
      };
    };
}
