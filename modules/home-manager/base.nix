{
  inputs,
  pkgs,
  ...
}: {
  nixpkgs = {
    overlays = [
      inputs.self.overlays.additions
      inputs.self.overlays.modifications
      inputs.self.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };

  home.packages = with pkgs; [
    pkg-config

    jq
    fd
    fzf
    bat
    procs
    unzip
    zoxide
    ripgrep
  ];

  programs.home-manager.enable = true;
  programs.yazi.enable = true;

  news.display = "silent"; # supress unread news notification
}
