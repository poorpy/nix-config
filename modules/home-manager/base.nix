{ inputs, pkgs, lib, config, ... }: {
  home.packages = with pkgs; [
    sumneko-lua-language-server
    stylua
    nixd
    nixpkgs-fmt

    nodePackages.vscode-json-languageserver-bin
    nodePackages.vscode-html-languageserver-bin
    nodePackages.pyright

    jq
    fd
    fzf
    ripgrep
    python313
  ];
}
