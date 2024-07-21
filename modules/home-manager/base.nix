{ inputs, pkgs, lib, config, ... }: {
  home.packages = with pkgs; [
    sumneko-lua-language-server
    vscode-langservers-extracted
    stylua
    nixd
    nixpkgs-fmt
    lazygit
    pre-commit
    pkg-config



    ruff
    mypy
    pyright
    python313
    python312Packages.ptpython

    devenv
    starship

    jq
    fd
    fzf
    unzip
    zoxide
    ripgrep
  ];
}
