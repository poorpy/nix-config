{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    starship = {
      url = "https://gitlab.com/lanastara_foss/starship-jj/-/archive/0.6.1/starship-jj-0.6.1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
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
      packages = forAllSystems (stdenv:
        let pkgs = nixpkgs.legacyPackages.${stdenv.hostPlatform.system};
        in import ./pkgs { inherit pkgs; }
      );
      # Devshell for bootstrapping
      # Acessible through 'nix develop' or 'nix-shell' (legacy)
      devShells = forAllSystems (stdenv:
        let pkgs = nixpkgs.legacyPackages.${stdenv.hostPlatform.system};
        in import ./shell.nix { inherit pkgs; }
      );

      overlays = import ./overlays { inherit inputs; };
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      homeConfigurations."poorpy@desktop" =
        home-manager.lib.homeManagerConfiguration
          {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs outputs; };
            modules = [ ./hosts/desktop/home-manager.nix ];
          };
	  
      homeConfigurations."poorpy@laptop" =
        home-manager.lib.homeManagerConfiguration
          {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs outputs; };
            modules = [ ./hosts/laptop/home-manager.nix ];
          };

      homeConfigurations."bmarczyn@muc-lhvsk4" =
        home-manager.lib.homeManagerConfiguration
          {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs outputs; };
            modules = [ ./hosts/engvm/home-manager.nix ];
          };

      homeConfigurations."bmarczyn@krk-mp6sf" =
        home-manager.lib.homeManagerConfiguration
          {
            pkgs = nixpkgs.legacyPackages.aarch64-darwin;
            extraSpecialArgs = { inherit inputs outputs; };
            modules = [ ./hosts/darwin/home-manager.nix ];
          };

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
