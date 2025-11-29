{ pkgs, ... }: {
  home.packages = with pkgs; [
    lua51Packages.lua
    lua51Packages.luarocks
    lua-language-server
    vscode-langservers-extracted
    stylua
    nixd
    nixpkgs-fmt
    lazygit
    pre-commit
    pkg-config

    starship

    jq
    fd
    fzf
    unzip
    zoxide
    ripgrep
    master.jujutsu
  ];

  programs.home-manager.enable = true;
  programs.yazi.enable = true;
}
