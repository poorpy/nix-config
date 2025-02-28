{ inputs, pkgs, lib, config, ... }: {
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



    master.pipx
    master.ruff
    master.mypy
    master.pyright
    master.python313
    python312Packages.ptpython
    master.python312Packages.python-lsp-server

    devenv
    starship

    jq
    fd
    fzf
    unzip
    zoxide
    ripgrep
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    defaultEditor = true;
    package = pkgs.master.neovim-unwrapped;
  };
}
