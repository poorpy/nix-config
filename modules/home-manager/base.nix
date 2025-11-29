{ pkgs, ... }: {
  home.packages = with pkgs; [
    pkg-config

    jq
    fd
    fzf
    unzip
    zoxide
    ripgrep
  ];

  programs.home-manager.enable = true;
  programs.yazi.enable = true;

  news.display = "silent"; # supress unread news notification
}
