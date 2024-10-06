{ outputs, lib, pkgs, ... }: {
  imports = [
    ./home/git.nix

    ./../../modules/home-manager/zsh
    ./../../modules/home-manager/tmux
    ./../../modules/home-manager/wezterm
    ./../../modules/home-manager/starship
    ./../../modules/home-manager/base.nix
    ./../../modules/home-manager/languages/go.nix
    ./../../modules/home-manager/languages/rust.nix
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
    mpv
    sshping
    pgcli
    ffmpeg
    docker
    docker-compose
    git-lfs
    ccls
    bear
    postgresql
    colima
  ];

  programs.home-manager.enable = true;
  programs.yazi.enable = true;
  programs.wezterm.enable = true;
}
