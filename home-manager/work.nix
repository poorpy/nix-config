{ inputs, pkgs, lib, config, ... }: {
  
  home.packages = with pkgs; [
    slack
    zoom-us
    plantuml
    chromium
    nodejs_20
    unstable.husky
    nodePackages.typescript-language-server
    vscode
  ];
}
