{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./home/git.nix
    ./../../modules/home-manager/zsh
    ./../../modules/home-manager/wezterm
    ./../../modules/home-manager/base.nix
    ./../../modules/home-manager/languages/go.nix
    ./../../modules/home-manager/languages/rust.nix
    ./../../modules/home-manager/languages/python.nix
    ./../../modules/home-manager/languages/javascript.nix
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
    stateVersion = "23.11";
    homeDirectory = lib.mkDefault "/Users/bmarczyn";
  };

  home.packages = with pkgs; [
    p4
    docker
    docker-compose
    pgcli
    devenv
    ruff
    jq
  ];

  programs.home-manager.enable = true;
  programs.yazi.enable = true;
  programs.wezterm.enable = true;
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    defaultEditor = true;
  };
}
