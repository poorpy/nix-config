{ outputs, lib, pkgs, ... }: {
  imports = [
    ./../../modules/home-manager/zsh
    ./../../modules/home-manager/fish
    ./../../modules/home-manager/tmux
    ./../../modules/home-manager/wezterm
    ./../../modules/home-manager/starship

    ./../../modules/home-manager/base.nix
    ./../../modules/home-manager/git.nix
    ./../../modules/home-manager/neovim.nix
    ./../../modules/home-manager/jujutsu.nix

    ./../../modules/home-manager/languages/go.nix
    ./../../modules/home-manager/languages/python.nix
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

  neovim.enable = true;
  fish.enable = true;
  tmux = {
    enable = true;
    useFish = true;
  };

  git = {
    enable = true;
    user = {
      name = "Bartosz Marczyński";
      email = "bmarczyn@akamai.com";
    };
    settings = {
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

  home.packages = with pkgs; [
    cacert
    curl
  ];
}
