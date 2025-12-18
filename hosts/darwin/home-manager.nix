{ outputs, lib, pkgs, ... }: {
  imports = [
    ./../../modules/home-manager/base.nix
    ./../../modules/home-manager/git.nix
    ./../../modules/home-manager/jujutsu.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "bmarczyn";
    stateVersion = "25.11";
    homeDirectory = lib.mkDefault "/Users/bmarczyn";
  };

  git = {
    enable = true;
    userEmail = "bmarczyn@akamai.com";
    extraConfig = {
      url."ssh://git@git.source.akamai.com:7999" = {
        insteadOf = "https://git.source.akamai.com";
      };
    };
  };

  jujutsu = {
    enable = true;
    user = {
      email = "bmarczyn@akamai.com";
      name = "Bartosz Marczyński";
    };
  };
}
