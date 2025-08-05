{ inputs, pkgs, lib, config, ... }: {
  home.packages = with pkgs; [
    nodePackages.typescript-language-server
    nodePackages.eslint
    nodenv
    nodejs
  ];
}
