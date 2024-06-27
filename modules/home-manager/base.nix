{ inputs, pkgs, lib, config, ... }: {
  home.packages = with pkgs; [
    sumneko-lua-language-server
    stylua
    nixd
    nixpkgs-fmt
    lazygit
    pre-commit

    nodePackages.vscode-json-languageserver-bin
    nodePackages.vscode-html-languageserver-bin

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
