{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    starship = {
      url = "https://gitlab.com/lanastara_foss/starship-jj/-/archive/0.6.1/starship-jj-0.7.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    turso = {
      url = "github:tursodatabase/turso/v0.5.0";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    fix-python = {
      url = "github:GuillaumeDesforges/fix-python";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell/v4.7.5";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tree-sitter = {
      url = "github:tree-sitter/tree-sitter/v0.26.8";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    systems = [
      "aarch64-darwin"
      "x86_64-darwin"
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
    ];

    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    overlays = import ./overlays {inherit inputs;};
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    nixConfig = {
      extra-substituters = ["https://noctalia.cachix.org"];
      extra-trusted-public-keys = [
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];
    };

    homeConfigurations."poorpy@desktop" =
      home-manager.lib.homeManagerConfiguration
      {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs;};
        modules = [./hosts/desktop/home.nix];
      };

    homeConfigurations."poorpy@laptop" =
      home-manager.lib.homeManagerConfiguration
      {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs;};
        modules = [./hosts/laptop/home.nix];
      };

    homeConfigurations."bmarczyn@muc-lhvsk4" =
      home-manager.lib.homeManagerConfiguration
      {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs;};
        modules = [./hosts/engvm/home.nix];
      };

    homeConfigurations."bmarczyn@krk-mp6sf" =
      home-manager.lib.homeManagerConfiguration
      {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          overlays = [
            (final: prev: {
              fish = prev.fish.overrideAttrs (old: {
                allowSubstitutes = false;
              });
            })
          ];
        };
        extraSpecialArgs = {inherit inputs;};
        modules = [./hosts/darwin/home.nix];
      };

    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      system = "x86_64-linux";
      modules = [./hosts/laptop/default.nix];
    };

    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      system = "x86_64-linux";
      modules = [./hosts/desktop/default.nix];
    };
  };
}
