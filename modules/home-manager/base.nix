{ inputs, pkgs, lib, config, ... }: {
  home.packages = with pkgs; [
    sumneko-lua-language-server
    stylua
    nixd
    nixpkgs-fmt
    lazygit
    pre-commit

    vscode-langservers-extracted

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
