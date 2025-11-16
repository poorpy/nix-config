{ pkgs, ... }: {
  home.packages = with pkgs; [
    luajitPackages.luarocks
    sumneko-lua-language-server
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
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    defaultEditor = true;
    package = pkgs.master.neovim-unwrapped;
  };
}
