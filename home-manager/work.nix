{ inputs, pkgs, lib, config, ... }: {
  
  home.packages = with pkgs; [
    slack
    zoom-us
    plantuml
    chromium
    nodejs_18
    unstable.husky
    nodePackages.typescript-language-server
    vscode
  ];
}
